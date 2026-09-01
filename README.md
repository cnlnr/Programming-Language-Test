# Programming-Language-Test

多语言编程环境检测 + 跨语言性能基准测试项目，用于检测当前系统中已安装的语言，并对不同语言进行统一基准测试，比较它们在 CPU 运算和数据处理方面的实际表现。

## 3. 支持语言列表

当前项目分成两部分：

- 当前已纳入 benchmark runner 的语言（实际可跑）
- 环境检测中已确认安装的语言（可检测，但未必已做统一 benchmark）

### 当前已纳入 benchmark runner 的语言

- Python
- JavaScript
- Java
- C++
- C#
- Ruby
- PHP
- Go
- Rust
- Dart
- R
- Perl
- Lua
- Haskell
- Nim
- D
- Zig
- Racket
- Erlang
- Clojure
- Elixir
- Fortran
- Julia
- Odin
- V

### 已安装但尚未全部接入 runner 的语言

- Ada
- C3
- Mojo
- Roc
- Solidity

这些语言已在 `test_environment.py` 中加入检测命令，并且不少已安装命令可直接识别；不过在统一 benchmark 流程中，仍需要按 `runner/config.json` 的方式补齐 `compile`/`command` 和 benchmark 实现后，才能纳入完整跑批。

## 项目结构

项目按“测试实现、统一运行、结果保存”三部分组织：

```text
Programming-Language-Test/
├── README.md
├── LICENSE
├── test_environment.py              # 检测本机已安装的语言和版本
├── benchmarks/                      # 各语言的合并测试程序
│   ├── benchmark.py                 # Python：递归 Fibonacci + 素数筛 + 非递归数值测试
│   ├── benchmark.js                 # JavaScript：递归 Fibonacci + 素数筛 + 非递归数值测试
│   ├── benchmark.cpp                # C++：递归 Fibonacci + 素数筛 + 非递归数值测试
│   └── ...                           # 其他语言各一个文件
├── runner/                          # 一键测试入口
│   ├── config.json                  # 各语言编译和运行命令
│   └── run_benchmarks.py            # 编译、运行、计时和生成 CSV
└── results/                         # 测试结果目录
    └── benchmark_results.csv
```

每个语言只对应一个 benchmark 文件，文件内部同时执行三项测试。语言程序只输出三个耗时数据，不打印 CSV 表头；`runner/run_benchmarks.py` 统一负责添加语言名、状态和表头，避免重复处理结果格式。

## 测试内容

- **斐波那契递归**：纯 CPU 运算与函数调用/递归开销。
- **素数筛（Sieve of Eratosthenes）**：循环、数组读写、内存访问性能。
- **非递归数值测试**：循环实现的 Fibonacci 数值计算，重复执行并累加结果，观察迭代计算性能。

## Python 参考模板

`benchmarks/benchmark.py` 是本项目唯一的参考模板。其他语言的 benchmark 应按照它实现相同的三项测试、计时方式和三字段输出协议，不在各语言文件中写死测试规模。

测试规模由 `runner/run_benchmarks.py` 统一控制。修改 runner 中的 Fibonacci 输入值和素数筛上限后，所有语言会使用同一组测试参数。

每个 benchmark 只输出一行三个耗时数据和三个计算结果，不输出表头：

```text
fibonacci_time_sec,prime_time_sec,iterative_numeric_time_sec,fibonacci_result,prime_result,iterative_numeric_result
```

runner 负责传入测试参数、编译和运行各语言程序，并校验三个计算结果；计算结果只用于验证，不写入 CSV。runner 还会统计对应 benchmark 源文件中去除所有空白字符后的字符数，记录为 `code_chars_no_whitespace`。第三项测试的迭代次数由 runner 统一控制，当前为 `2_000_000`；默认 Fibonacci 输入为 `37`，素数筛上限为 `2_000_000`。CSV 字段为 `language,status,fibonacci_time_sec,prime_time_sec,iterative_numeric_time_sec,code_chars_no_whitespace,total_time_sec,error`。不同机器的耗时会不同，因此只比较同一台机器、相同输入规模和相同编译优化条件下的结果。
