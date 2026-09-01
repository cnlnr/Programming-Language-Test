#!/usr/bin/env python3
"""
Programming Language Environment Tester
检测系统中已安装的编程语言
"""

import subprocess
import sys
import platform
from typing import Dict, Tuple

# 定义编程语言及其检测命令
LANGUAGES = {
    "Python": ("python --version", "py --version"),
    "JavaScript": ("node --version",),
    "Java": ("java -version",),
    "C++": ("g++ --version", "clang++ --version", "cl.exe /?"),
    "C#": ("dotnet --version", "csc.exe -help", "csc --version"),
    "Ruby": ("ruby --version",),
    "PHP": ("php --version",),
    "Go": ("go version",),
    "Rust": ("rustc --version",),
    "Dart": ("dart --version",),
    "R": ("R --version", "Rscript --version"),
    "Perl": ("perl --version",),
    "Lua": ("lua -v",),
    "Haskell": ("ghc --version",),
    "Elixir": ("elixir --version",),
    "Erlang": ("erl -noshell -eval \"erlang:display(erlang:system_info(otp_release)), halt().\"",),
    "Clojure": ("clojure -version", "clj -Sdescribe"),
    "Nim": ("nim --version",),
    "D": ("dmd --version",),
    "Zig": ("zig version",),
    "Julia": ("julia --version", "juliaup --version", "julia --help"),
    "Fortran": ("gfortran --version",),
    "Ada": ("alr --version", "gnatmake --version"),
    "Mojo": ("mojo --help", "mojo run --help"),
    "Odin": ("odin version",),
    "C3": ("c3c --version",),
    "Racket": ("racket --version",),
    "Solidity": ("solc --version",),
    "Roc": ("roc --version", "roc check --help"),
    "V": ("v version",),
}


def check_language(lang_name: str, commands: Tuple[str, ...]) -> Dict[str, any]:
    """
    检测编程语言是否已安装
    
    Args:
        lang_name: 语言名称
        commands: 检测命令元组
        
    Returns:
        包含状态和版本信息的字典
    """
    not_found_indicators = [
        "不是内部或外部命令",
        "不是可运行的程序",
        "is not recognized",
        "not found",
        "找不到",
        "command not found",
        "no such file",
        "找不到指定的文件"
    ]
    
    for cmd in commands:
        try:
            result = subprocess.run(
                cmd,
                shell=True,
                capture_output=True,
                text=True,
                timeout=3,
                stdin=subprocess.DEVNULL,
            )
            
            output = (result.stdout + result.stderr).strip()
            
            # 检查是否包含"未找到"的指示
            if any(indicator in output.lower() for indicator in not_found_indicators):
                continue
            
            # 如果有输出且没有"未找到"提示，则认为已安装
            if output:
                version_info = output.split('\n')[0]
                return {
                    "status": "[OK] 已安装",
                    "version": version_info[:80],
                    "command": cmd
                }
        except subprocess.TimeoutExpired:
            continue
        except Exception:
            continue
    
    return {
        "status": "[XX] 未安装",
        "version": "",
        "command": ""
    }


def main():
    """主函数"""
    print("=" * 80)
    print("编程语言环境检测工具")
    print("系统: {} {}".format(platform.system(), platform.release()))
    print("Python: {}".format(sys.version.split()[0]))
    print("=" * 80)
    print()
    
    results = {}
    installed_count = 0
    total_count = len(LANGUAGES)
    
    print("检测中...")
    print()
    
    for lang_name in sorted(LANGUAGES.keys()):
        commands = LANGUAGES[lang_name]
        result = check_language(lang_name, commands)
        results[lang_name] = result
        
        if "已安装" in result["status"]:
            installed_count += 1
        
        print("{} {:<15} {:<15} {}".format(result['status'], lang_name, "", result['version']))
    
    print()
    print("=" * 80)
    print("统计信息: {}/{} 语言已安装".format(installed_count, total_count))
    print("=" * 80)
    
    # 详细列表
    print("\n[OK] 已安装的语言:")
    installed_langs = [lang for lang, result in results.items() if "已安装" in result["status"]]
    if installed_langs:
        for lang in sorted(installed_langs):
            print("  - {}: {}".format(lang, results[lang]['version']))
    else:
        print("  无")
    
    print("\n[XX] 未安装的语言:")
    uninstalled_langs = [lang for lang, result in results.items() if "未安装" in result["status"]]
    if uninstalled_langs:
        for lang in sorted(uninstalled_langs):
            print("  - {}".format(lang))
    else:
        print("  无")
    
    print()
    return 0 if uninstalled_langs else 1


if __name__ == "__main__":
    sys.exit(main())
