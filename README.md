# C++ CMake Starter

A small C++20 executable template with target-scoped compiler settings, CMake
presets, a CTest smoke test, optional clang-tidy analysis, and optional sanitizers.
There are no external library dependencies or automatic downloads.

## Requirements

- CMake 3.25 or newer.
- A compiler supporting C++20.
- Ninja when using the supplied presets.
- clang-tidy when using the `tidy` preset; other presets do not require it.

On Windows, run the preset commands from a developer shell with the compiler
available. The sanitizer preset requires GCC or a GNU-style Clang toolchain and
platform support for AddressSanitizer and UndefinedBehaviorSanitizer; it does not
support MSVC or clang-cl.

## Start a project

1. Copy this directory, or publish it as a GitHub template repository and select
   **Use this template** for each new project.
2. Change `cpp_starter` and the version in the root `CMakeLists.txt`. The project
   name is also the executable name; use a simple name without spaces.
3. Rename the `CPP_STARTER_` option prefix in `CMakeLists.txt`,
   `cmake/CompilerOptions.cmake`, and `CMakePresets.json` if desired. You can also
   rename `cpp_starter_apply_compiler_options` in the module and its root call.
   Update the example commands below to match.
4. Replace `src/main.cpp`, update the smoke test in `tests/CMakeLists.txt`, and
   replace this README with your project documentation.
5. Choose a license before publishing your project.

No Git repository is initialized automatically.

## Everyday commands

Run these commands from the project root:

```sh
cmake --preset dev
cmake --build --preset dev
ctest --preset dev
```

The executable is `build/dev/cpp_starter` (`cpp_starter.exe` on Windows).
Configuration is needed initially and after changing cache options; normal
source edits only need the build and test commands.

Release builds use a separate directory:

```sh
cmake --preset release
cmake --build --preset release
ctest --preset release
```

To check for memory errors and undefined behavior on a supported toolchain:

```sh
cmake --preset sanitize
cmake --build --preset sanitize
ctest --preset sanitize
```

## Static analysis with clang-tidy

The opt-in `tidy` preset inherits the debug settings and runs clang-tidy alongside
compilation for the executable target:

```sh
cmake --preset tidy
cmake --build --preset tidy
ctest --preset tidy
```

Configuration fails if clang-tidy cannot be found. To select a versioned or
nonstandard executable, configure with
`-DCPP_STARTER_CLANG_TIDY=/path/to/clang-tidy`.

`.clang-tidy` enables the Clang static analyzer, bug-prone and performance checks,
and selected modernization checks. It avoids blanket style enforcement and does
not apply automatic fixes. Analysis warnings are not errors by default; adjust
`WarningsAsErrors` in `.clang-tidy` if you want a strict analysis gate. The
`CPP_STARTER_WARNINGS_AS_ERRORS` option controls compiler warnings separately.

Analysis runs only for source files being compiled, so an unchanged build does
not rerun it. Force a complete pass after changing `.clang-tidy` with:

```sh
cmake --build --preset tidy --clean-first
```

The preset uses the same default compiler selection as `dev`; it does not force
Clang as the compiler. Use a clang-tidy version that understands your compiler's
C++ standard library headers, or select a compatible Clang toolchain in a local
preset if needed. Normal `dev` and `release` builds remain unaffected.

Available presets can be listed with `cmake --list-presets`,
`cmake --build --list-presets`, and `ctest --list-presets`.

## Formatting

Use 2-space indentation. `.clang-format` configures C++ formatting with spaces
instead of tabs and preserves the starter's next-line brace style. clang-format
is optional and is not run automatically during builds.

Format a source file or check its formatting without changing it:

```sh
clang-format -i src/main.cpp
clang-format --dry-run --Werror src/main.cpp
```

## Common changes

Add source files to `add_executable()` in `CMakeLists.txt`. Set include directories,
compile definitions, and dependencies with `target_include_directories()`,
`target_compile_definitions()`, and `target_link_libraries()` on that target rather
than setting directory-wide flags. Compiler warnings are enabled by default.

`cmake/CompilerOptions.cmake` defines `cpp_starter_apply_compiler_options(target)`
to apply warnings, sanitizers, and clang-tidy settings to an individual target.
Options remain declared in the root `CMakeLists.txt`. Call the helper after
creating each additional library or test target that needs those settings.

Treat warnings as errors when wanted:

```sh
cmake --preset dev -DCPP_STARTER_WARNINGS_AS_ERRORS=ON
```

Cache options persist in that build directory. Pass `OFF` to disable the option
again, or use `cmake --fresh --preset dev` to reset the cache.

The included test checks that the executable exits successfully. It is not a
unit-test framework. Add focused tests under `tests/` as the project grows.
When code needs direct unit testing, move reusable logic into a library target
and link both the executable and its tests to it.

Build without tests or without Ninja/presets:

```sh
cmake -S . -B build/manual -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
cmake --build build/manual --config Release
```

Install a release build to a directory you choose:

```sh
cmake --install build/release --prefix /path/to/install
```

## Local configuration

`CMakePresets.json` is shared project configuration. Keep machine-specific
settings in an ignored `CMakeUserPresets.json` instead. For example, to use Clang
without changing the shared presets:

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "local-clang",
      "inherits": "dev",
      "cacheVariables": {
        "CMAKE_CXX_COMPILER": "clang++"
      }
    }
  ],
  "buildPresets": [
    { "name": "local-clang", "configurePreset": "local-clang" }
  ],
  "testPresets": [
    {
      "name": "local-clang",
      "configurePreset": "local-clang",
      "output": { "outputOnFailure": true },
      "execution": { "noTestsAction": "error" }
    }
  ]
}
```

Then use `local-clang` in place of `dev` in the configure, build, and test commands.
Each configure preset has its own build directory, so different compilers do not
share a CMake cache.

The Ninja presets export `compile_commands.json` into their build directories for
editors and analysis tools. Point your editor at the relevant directory, or create
an ignored root-level symlink to that file if your editor requires one.
