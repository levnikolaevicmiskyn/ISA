#ifndef ALU_ALU_H
#define ALU_ALU_H

#include <iostream>
#include <cinttypes>
#include <exception>
#include <map>
#include <functional>

class ALU {
public:
    // Types
    // Must use unsigned integers because the sign bit is protected and overflow is not allowed
    using dtype = uint32_t;
    struct Input {
        dtype operand1;
        dtype operand2;
        int control;
    };
    struct Output {
        dtype result;
        int N;
        int Z;
        int C;
        int V;
    };
    using ALUFunction = std::function<dtype(const Input &)>;
private:
    // Static variables
    static const int N_INPUT_FIELDS = 3;
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
    // Errors
    class InputFormatError : public std::runtime_error {
    public:
        InputFormatError(const std::string &msg);
    };
private:
    // ALU internal operations
    static dtype _add(const Input &input);
    static dtype _sub(const Input &input);
    static dtype _srai(const Input &input);
    static dtype _and(const Input &input);
    static dtype _xor(const Input &input);
    static dtype _lt(const Input &input);
    static dtype _abs(const Input &input);
    // Opcode to function mapper
    static const std::map<int, ALUFunction> functions;
};

#endif //ALU_ALU_H
