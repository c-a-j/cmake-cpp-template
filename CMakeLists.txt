cmake_minimum_required(VERSION 3.25)

project(cpp_starter VERSION 0.1.0 LANGUAGES CXX)

option(PROJECT_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" OFF)
option(PROJECT_ENABLE_SANITIZERS "Enable AddressSanitizer and UndefinedBehaviorSanitizer" OFF)
option(PROJECT_ENABLE_CLANG_TIDY "Run clang-tidy during compilation" OFF)

include(cmake/CompilerOptions.cmake)

add_library(${PROJECT_NAME}_lib STATIC
  src/lib.cpp
  include/lib.hpp
)
target_include_directories(${PROJECT_NAME}_lib
  PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

add_executable(${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_EXTENSIONS OFF)

cpp_starter_apply_compiler_options(${PROJECT_NAME})

include(CTest)
if(BUILD_TESTING)
  add_subdirectory(tests)
endif()

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
