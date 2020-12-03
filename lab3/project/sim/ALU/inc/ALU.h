#ifndef ALU_ALU_H
#define ALU_ALU_H

#include<iostream>
#include <cinttypes>
#include <map>
#include <functional>

class ALU {
public:
    // Types
    // Must use unsigned integers because the sign bit is protected and overflow is not allowed
    using dtype = uint32_t;
    struct Input {
        int opcode;
        dtype operand1;
        dtype operand2;
    };
    struct Output {
        dtype result;
    };
    using ALUFunction = std::function<Output(const Input &)>;
private:
    // Attributes
    Input m_input;
    Output m_output;
public:
    ALU();
    // ALU state
    const Input &input() const;
    const Output &output() const;
    // Execution
    const Output &executeStep(const Input &input);
    const Output &executeStep(const std::string &instruction);
    void executeStream(std::istream &istream, std::ostream &ostream);
    // I/O operations
    static Input parseInputString(const std::string &instruction);
    static std::string formatOutputString(const Output &output);

private:
    // ALU internal operations
    static Output _add(const Input &input);
    static Output _srai(const Input &input);
    // Opcode to function mapper
    static const std::map<int, ALUFunction> functions;
};

#endif //ALU_ALU_H
