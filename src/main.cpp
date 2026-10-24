#include <iostream>

#include "lib.hpp"

int main(int argc, char **argv) {
  if (argc == 1) {
    std::cout << "Hello, world!\n";
    return 0;
  } else if (argc == 2) {
    lib::hello(argv[1]);
    return 0;
  }
  return 1;
}
