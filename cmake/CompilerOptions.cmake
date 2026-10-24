function(cpp_starter_apply_compiler_options target)
  if(MSVC)
    target_compile_options(${target} PRIVATE /W4 /permissive-)
    if(CPP_STARTER_WARNINGS_AS_ERRORS)
      target_compile_options(${target} PRIVATE /WX)
    endif()
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
    target_compile_options(${target} PRIVATE -Wall -Wextra -Wpedantic)
    if(CPP_STARTER_WARNINGS_AS_ERRORS)
      target_compile_options(${target} PRIVATE -Werror)
    endif()
  endif()

  if(CPP_STARTER_ENABLE_SANITIZERS)
    if(NOT MSVC AND CMAKE_CXX_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
      target_compile_options(${target} PRIVATE
        -fsanitize=address,undefined
        -fno-omit-frame-pointer
      )
      target_link_options(${target} PRIVATE -fsanitize=address,undefined)
    else()
      message(FATAL_ERROR "The sanitizer option requires GCC or a GNU-style Clang toolchain.")
    endif()
  endif()

  if(CPP_STARTER_ENABLE_CLANG_TIDY)
    find_program(CPP_STARTER_CLANG_TIDY NAMES clang-tidy REQUIRED)
    set_property(TARGET ${target} PROPERTY CXX_CLANG_TIDY
      "${CPP_STARTER_CLANG_TIDY};--config-file=${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../.clang-tidy"
    )
  endif()
endfunction()
