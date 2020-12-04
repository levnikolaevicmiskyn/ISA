#include <iostream>
#include "../inc/ALU.h"

int main() {
    ALU alu;
    alu.executeStream(std::cin, std::cout);
    return 0;
}
