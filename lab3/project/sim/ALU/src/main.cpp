#include <iostream>
#include <fstream>
#include "../inc/ALU.h"

int main() {
    ALU alu;
    std::ifstream infile;
    infile.open("inputs.txt");
    alu.executeStream(infile, std::cout);
    return 0;
}
