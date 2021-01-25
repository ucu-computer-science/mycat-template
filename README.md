# mycat

## Team

 - [Volodymyr Chernetskyi](https://github.com/chernetskyi)

## Usage

```bash
mycat [OPTION]... [FILE]...
```

Reads specified files to stdout.

If one of the multiple files cannot be read, `mycat` will fail and print nothing to stdout.

Option `-A` replaces invisible non-whitespace characters with their hexadecimal values.

Help flags `-h`/`--help` support is available.

## Prerequisites

 - **C++ compiler** - needs to support **C++17** standard
 - **CMake** 3.15+
 
Dependencies (such as development libraries) can be found in the [dependencies folder](./dependencies) in the form of the text files with package names for different package managers.

## Installing

1. Clone the project.
    ```bash
    git clone git@github.com:chernetskyi/mycat-template.git
    ```
2. Install required packages.

   On Ubuntu:
   ```bash
   [[ -r dependencies/apt.txt ]] && sed 's/#.*//' dependencies/apt.txt | xargs sudo apt-get install -y
   ```
   On MacOS:
   ```bash
   [[ -r dependencies/homebrew.txt ]] && sed 's/#.*//' dependencies/homebrew.txt | xargs brew install
   ```
   Use Conan on Windows.
3. Build.
    ```bash
    cmake -Bbuild
    cmake --build build
    ```
4. Test.
    ```bash
    tests/runtests.sh ./build ./tests
    ```
