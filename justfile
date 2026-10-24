# List available recipes.
default:
  @just --list

# Configure a build directory. Defaults to clang-tidy analysis.
configure preset="debug" tests="OFF":
  @cmake --preset "{{ preset }}" -DBUILD_TESTING="{{ tests }}"

# Configure, then compile and link.
build preset="debug" tests="OFF": (configure preset tests)
  @cmake --build --preset "{{ preset }}"

# Configure, build, then run tests.
test preset="debug": (build preset "ON")
  @GTEST_BRIEF=1 GTEST_COLOR=yes ctest --preset "{{ preset }}"

# Format C and C++ sources and headers under src and tests.
format:
  @find src tests -type f \
    \( -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \
    -o -name '*.cc' -o -name '*.hh' -o -name '*.cxx' -o -name '*.hxx' \) \
    -exec clang-format -i {} +

# Rebuild every source file to force a complete clang-tidy pass.
lint: (configure "debug")
  @cmake --build --preset tidy --clean-first

