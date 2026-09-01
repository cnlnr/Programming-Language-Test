from __future__ import annotations

import csv
import json
import argparse
import shutil
import subprocess
import sys
import time
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
CONFIG_PATH = ROOT / "runner" / "config.json"
RESULTS_PATH = ROOT / "results" / "benchmark_results.csv"
FIBONACCI_INPUT = 37
PRIME_LIMIT = 2_000_000
CSV_FIELDS = [
    "language", "status", "fibonacci_time_sec", "prime_time_sec",
    "total_time_sec", "error",
]


def log(message: str) -> None:
    print(message, file=sys.stderr, flush=True)


def command_exists(command: list[str]) -> bool:
    executable = command[0]
    return shutil.which(executable) is not None or (ROOT / executable).exists()


def run_command(command: list[str]) -> subprocess.CompletedProcess[str]:
    executable = command[0]
    if shutil.which(executable) is None and (ROOT / executable).exists():
        command = [str(ROOT / executable), *command[1:]]
    return subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True,
        encoding="utf-8", errors="replace",
    )


def parse_output(output: str) -> tuple[str, str]:
    for line in reversed(output.splitlines()):
        values = [value.strip() for value in line.split(",")]
        if len(values) == 2:
            return tuple(values)  # type: ignore[return-value]
    raise ValueError(f"expected 2 comma-separated timing values, got: {output!r}")


def execute(
    language: str, settings: dict[str, Any], position: int, total: int,
) -> dict[str, Any]:
    row: dict[str, Any] = {field: "" for field in CSV_FIELDS}
    row["language"] = language
    if not command_exists(settings.get("compile", settings["command"])):
        row["status"] = "skipped"
        row["error"] = f"command not found: {settings.get('compile', settings['command'])[0]}"
        return row

    if "compile" in settings:
        compile_result = run_command(settings["compile"])
        if compile_result.returncode != 0:
            row["status"] = "failed"
            row["error"] = " ".join((compile_result.stderr or compile_result.stdout).split())
            return row

    if not command_exists(settings["command"]):
        row["status"] = "skipped"
        row["error"] = f"command not found: {settings['command'][0]}"
        return row

    started = time.perf_counter()
    result = run_command(settings["command"] + [str(FIBONACCI_INPUT), str(PRIME_LIMIT)])
    if result.returncode != 0:
        row["status"] = "failed"
        row["error"] = " ".join((result.stderr or result.stdout).split())
        return row

    try:
        fibonacci_time, prime_time = parse_output(
            f"{result.stdout}\n{result.stderr}"
        )
    except ValueError as error:
        row["status"] = "failed"
        row["error"] = str(error)
        return row

    row.update({
        "status": "ok",
        "fibonacci_time_sec": fibonacci_time,
        "prime_time_sec": prime_time,
    })
    return row


def main() -> int:
    parser = argparse.ArgumentParser(description="Run configured language benchmarks.")
    parser.add_argument(
        "--no-save", action="store_true",
        help="print benchmark rows without writing the results CSV",
    )
    parser.add_argument(
        "--output", type=Path, default=RESULTS_PATH,
        help="write results to this CSV path instead of the default",
    )
    args = parser.parse_args()
    config = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    total = len(config)
    log(
        f"Starting benchmark run: {total} languages "
        f"(fib={FIBONACCI_INPUT}, prime_limit={PRIME_LIMIT})"
    )
    rows = []
    for position, (language, settings) in enumerate(config.items(), start=1):
        started = time.perf_counter()
        row = execute(language, settings, position, total)
        row["total_time_sec"] = f"{time.perf_counter() - started:.6f}"
        rows.append(row)
        message = f"[{position}/{total}] {language}: {row['status']} in {row['total_time_sec']}s"
        if row["status"] != "ok" and row["error"]:
            message += f" ({row['error']})"
        log(message)
    print(",".join(CSV_FIELDS))
    for row in rows:
        print(",".join(str(row[field]) for field in CSV_FIELDS))
    if not args.no_save:
        args.output.parent.mkdir(exist_ok=True)
        with args.output.open("w", newline="", encoding="utf-8") as output:
            writer = csv.DictWriter(output, fieldnames=CSV_FIELDS)
            writer.writeheader()
            writer.writerows(rows)
        print(f"\nCSV saved to: {args.output}")
        log(f"Benchmark run complete. CSV saved to: {args.output}")
    else:
        log("Benchmark run complete. Results were not saved (--no-save).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
