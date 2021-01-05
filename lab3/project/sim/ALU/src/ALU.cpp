#include "../inc/ALU.h"
#include <vector>
#include <sstream>
#include <iomanip>

const std::map<int, ALU::ALUFunction> ALU::functions = {
        {0, ALU::_add},
        {1, ALU::_srai},
        {2, ALU::_and},
        {3, ALU::_xor},
        {6, ALU::_sub}
};

ALU::ALU() : m_input{0, 0, 0},
             m_output{0, 0, 0, 0, 0} {}

const ALU::Input &ALU::input() const {
    return m_input;
}

const ALU::Output &ALU::output() const {
    return m_output;
}

const ALU::Output &ALU::executeStep(const Input &input) {
    m_input = input;
    const ALUFunction &function = functions.at(input.control);
    m_output.result = function(m_input);
    // Mask result for safety
    m_output.result &= 0xffffffff;
    return m_output;
}

const ALU::Output &ALU::executeStep(const std::string &instruction) {
    Input input = parseInputString(instruction);
    return executeStep(input);
}

void ALU::executeStream(std::istream &istream, std::ostream &ostream) {
    // Read input stream line by line
    std::string line;
    while (istream.good()) {
        std::getline(istream, line);
        if (!line.empty()) {
            executeStep(line);
            ostream << formatOutputString(m_output) << std::endl;
        }
    }
}

ALU::Input ALU::parseInputString(const std::string &instruction) {
    Input input{};
    // Load input into a stringstream
    std::stringstream inputss;
    inputss << instruction;
    // Extract fields one by one
    std::vector<std::string> fields;
    while (inputss.good()) {
        std::string field;
        inputss >> field;
        fields.push_back(field);
    }
    if (fields.size() != N_INPUT_FIELDS) {
        std::stringstream errorss;
        errorss << "Bad input format on line `" << instruction << "`."
                << "The input line has " << fields.size() << " field(s), but " << N_INPUT_FIELDS << " were expected."
                << std::endl;
        throw ALU::InputFormatError(errorss.str());
    }
    // Store fields in another stringstream, preceded by the correct format characters
    std::stringstream outputss;
    for (const std::string &field : fields) {
        outputss << std::hex << field << ' ';
    }
    // Store fields in the struct
    outputss >> input.operand1
             >> input.operand2
             >> input.control;
    return input;
}

std::string ALU::formatOutputString(const Output &output) {
    std::stringstream ss;
    ss << std::setfill('0') << std::setw(32 / 4) << std::hex << output.result; /* << " "
       << output.N << " "
       << output.Z << " "
       << output.C << " "
       << output.V << " "; */
    return ss.str();
}


ALU::dtype ALU::_add(const Input &input) {
    return input.operand1 + input.operand2;
}

ALU::dtype ALU::_sub(const Input &input) {
    return input.operand1 - input.operand2;
}

ALU::dtype ALU::_srai(const Input &input) {
    // Only the last 5 significant bits are considered
    dtype shift_amount = input.operand2 & ((0x1 << 5) - 1);
    dtype result = input.operand1 >> shift_amount;
    // Data is unsigned, so the sign should be handled manually
    dtype MSB = (input.operand1 & 0x80000000);
    if (MSB != 0) {
        dtype sign_ext_mask = ((dtype) -1) & ~((MSB >> shift_amount) - 1);
        result |= sign_ext_mask;
    }
    return result;
}

ALU::dtype ALU::_and(const Input &input) {
    return input.operand1 & input.operand2;
}

ALU::dtype ALU::_xor(const Input &input) {
    return input.operand1 ^ input.operand2;
}

ALU::InputFormatError::InputFormatError(const std::string &msg) : std::runtime_error(msg) {}
