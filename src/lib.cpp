#include <iostream>
#include <string_view>

namespace lib {
void hello(std::string_view name) {
    std::cout << "Hello, " << name << "!\n";
}
}
