# Dev Tools Cheat Sheet

## C/C++ build

| Command | Meaning |
|---|---|
| `cmake -S . -B build -G Ninja` | Configure CMake project |
| `cmake --build build` | Build project |
| `ctest --test-dir build --output-on-failure` | Run CTest tests |

## C/C++ format and static analysis

| Command | Meaning |
|---|---|
| `clang-format -i file.cpp` | Format C/C++ file |
| `clang-tidy file.cpp --` | Run clang-tidy |
| `cppcheck --enable=all .` | Run cppcheck static analysis |

## Debugging

| Command | Meaning |
|---|---|
| `gdb ./program` | Debug with GDB |
| `lldb ./program` | Debug with LLDB |
| `valgrind ./program` | Check memory errors on Linux/WSL |
| `strace ./program` | Trace syscalls on Linux/WSL |
| `ltrace ./program` | Trace library calls on Linux/WSL |

## Binary / assembly inspection

| Command | Meaning |
|---|---|
| `objdump -d ./program` | Disassemble binary |
| `readelf -a ./program` | Inspect ELF binary |
| `nm ./program` | List symbols |
| `addr2line -e ./program 0xADDRESS` | Map address to source line |
| `xxd file.bin` | Hex dump |
| `nasm -f elf64 file.asm -o file.o` | Assemble x86-64 assembly on Linux |

## Compile database

| Command | Meaning |
|---|---|
| `bear -- make` | Generate compile_commands.json for Make projects |
| `cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` | Generate compile_commands.json with CMake |

## Python testing

| Command | Meaning |
|---|---|
| `pytest` | Run Python tests |
| `pytest -q` | Run quiet pytest |
| `pytest tests/test_file.py` | Run one test file |
| `ruff check .` | Python lint |
| `ruff format .` | Python format |
| `mypy .` | Python type check |

## Coverage

| Command | Meaning |
|---|---|
| `gcovr -r .` | C/C++ coverage summary |
| `gcovr -r . --html --html-details -o coverage.html` | C/C++ HTML coverage |
| `lcov --capture --directory . --output-file coverage.info` | Capture lcov data |


## GitHub CLI

| Command | Meaning |
|---|---|
| `gh auth login` | Login to GitHub |
| `gh auth status` | Check GitHub login |
| `gh repo create` | Create a GitHub repo |
| `gh repo view --web` | Open repo in browser |
| `gh pr create` | Create pull request |
| `gh pr status` | Show PR status |
