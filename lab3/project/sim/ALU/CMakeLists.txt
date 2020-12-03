cmake_minimum_required(VERSION 3.17)
project(ALU)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_FLAGS "-Wall -Werror")
add_executable(ALU src/main.cpp src/ALU.cpp)