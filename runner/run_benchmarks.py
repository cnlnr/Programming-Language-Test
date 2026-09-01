from __future__ import annotations

import csv
import json
import argparse
import math
from decimal import Decimal, InvalidOperation
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
NUMERIC_ITERATIONS = 2_000_000
SOURCE_EXTENSIONS = {
    "python": ".py", "javascript": ".js", "cpp": ".cpp", "java": ".java",
    "csharp": ".cs", "ruby": ".rb", "php": ".php", "go": ".go",
    "rust": ".rs", "dart": ".dart", "perl": ".pl", "lua": ".lua",
    "nim": ".nim", "d": ".d", "zig": ".zig", "r": ".r", "haskell": ".hs",
    "racket": ".rkt", "erlang": ".erl", "odin": ".odin", "v": ".v",
}
CSV_FIELDS = [
    "language", "status", "fibonacci_time_sec", "prime_time_sec",
    "iterative_numeric_time_sec", "code_chars_no_whitespace",
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


def source_file_for(language: str) -> Path:
    extension = SOURCE_EXTENSIONS[language.lower()]
    candidates = sorted((ROOT / "benchmarks").glob(f"*{extension}"))
    if not candidates:
        raise FileNotFoundError(f"benchmark source not found for {language}")
    return candidates[0]


def code_chars_no_whitespace(language: str) -> int:
    source = source_file_for(language).read_text(encoding="utf-8")
    return sum(not character.isspace() for character in source)


def parse_integer(value: str) -> int:
    normalized = value.strip().replace("_", "")
    if normalized.endswith(("n", "N")):
        normalized = normalized[:-1]
    try:
        number = Decimal(normalized)
    except InvalidOperation as error:
        raise ValueError(f"invalid integer value: {value!r}") from error
    if not number.is_finite() or number != number.to_integral_value():
        raise ValueError(f"invalid integer value: {value!r}")
    return int(number)


def parse_output(output: str) -> tuple[str, str, str, str, str, str]:
    for line in reversed(output.splitlines()):
        values = [value.strip() for value in line.split(",")]
        if len(values) == 6:
            return tuple(values)  # type: ignore[return-value]
    raise ValueError(f"expected 6 comma-separated values, got: {output!r}")


def expected_results() -> tuple[int, int, int]:
    def fibonacci(number: int) -> int:
        if number < 2:
            return number
        return fibonacci(number - 1) + fibonacci(number - 2)

    is_prime = [True] * (PRIME_LIMIT + 1)
    is_prime[0] = is_prime[1] = False
    for number in range(2, math.isqrt(PRIME_LIMIT) + 1):
        if is_prime[number]:
            for multiple in range(number * number, PRIME_LIMIT + 1, number):
                is_prime[multiple] = False
    fibonacci_result = fibonacci(FIBONACCI_INPUT)
    prime_result = sum(is_prime)
    return fibonacci_result, prime_result, fibonacci_result * NUMERIC_ITERATIONS


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
    result = run_command(settings["command"] + [
        str(FIBONACCI_INPUT), str(PRIME_LIMIT), str(NUMERIC_ITERATIONS),
    ])
    if result.returncode != 0:
        row["status"] = "failed"
        row["error"] = " ".join((result.stderr or result.stdout).split())
        return row

    try:
        values = parse_output(f"{result.stdout}\n{result.stderr}")
        times = [float(value) for value in values[:3]]
        if any(not math.isfinite(value) or value < 0 for value in times):
            raise ValueError("timings must be finite floating-point values >= 0")
        actual_results = [parse_integer(value) for value in values[3:]]
    except ValueError as error:
        row["status"] = "failed"
        row["error"] = str(error)
        return row

    expected = expected_results()
    result_names = ("fibonacci", "prime", "iterative_numeric")
    for name, actual, expected_value in zip(result_names, actual_results, expected):
        if actual != expected_value:
            row["status"] = "failed"
            row["error"] = (
                f"{name}_result mismatch: actual={actual}, "
                f"expected={expected_value}"
            )
            return row

    row.update({
        "status": "ok",
        "fibonacci_time_sec": values[0],
        "prime_time_sec": values[1],
        "iterative_numeric_time_sec": values[2],
        "code_chars_no_whitespace": code_chars_no_whitespace(language),
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
        f"(fib={FIBONACCI_INPUT}, prime_limit={PRIME_LIMIT}, "
        f"iterations={NUMERIC_ITERATIONS})"
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
    return 1 if any(row["status"] == "failed" for row in rows) else 0


if __name__ == "__main__":
    sys.exit(main())
