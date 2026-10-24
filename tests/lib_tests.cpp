#include <gtest/gtest.h>

#include <iostream>
#include <sstream>

#include "lib.hpp"

TEST(Greeting, NamedGreeting) {
  std::ostringstream captured;
  auto *original = std::cout.rdbuf(captured.rdbuf());

  lib::hello("foo");

  std::cout.rdbuf(original);

  EXPECT_EQ(captured.str(), "Hello, foo!\n");
}
