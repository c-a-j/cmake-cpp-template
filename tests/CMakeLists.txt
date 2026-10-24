include(FetchContent)
set(BUILD_GMOCK OFF CACHE BOOL "Build GoogleMock")
set(INSTALL_GTEST OFF CACHE BOOL "Install GoogleTest")
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.17.0.zip
)
FetchContent_MakeAvailable(googletest)

add_executable(lib_tests lib_tests.cpp)
target_link_libraries(lib_tests PRIVATE 
  ${PROJECT_NAME}_lib
  GTest::gtest_main
)
target_compile_features(lib_tests PRIVATE cxx_std_20)

include(GoogleTest)
gtest_discover_tests(lib_tests PROPERTIES TIMEOUT 10)
