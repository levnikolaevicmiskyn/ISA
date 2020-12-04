#include "../inc/ALU.h"
#include <vector>
#include <sstream>
#include <iomanip>

const std::map<int, ALU::ALUFunction> ALU::functions = {
        {0, ALU::_add},
        {1, ALU::_srai}
};

ALU::ALU() = default;

const ALU::Input &ALU::input() const {
    return m_input;
}

const ALU::Output &ALU::output() const {
    return m_output;
}

const ALU::Output &ALU::executeStep(const Input &input) {
    m_input = input;
    const ALUFunction &function = functions.at(input.opcode);
    m_output = function(m_input);
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
    outputss >> input.opcode
             >> input.operand1
             >> input.operand2
             >> input.immediate
             >> input.source;
    return input;
}

std::string ALU::formatOutputString(const Output &output) {
    std::stringstream ss;
    ss << std::setfill('0') << std::setw(32/4) << std::hex << output.result;
    return ss.str();
}

ALU::dtype ALU::_getRequestedSource(const Input &input) {
    switch(input.source) {
        case 0:
            return input.operand2;
        case 1:
            return input.immediate;
    }
    throw;
}

ALU::Output ALU::_add(const Input &input) {
    return Output{input.operand1 + _getRequestedSource(input)};
}

ALU::Output ALU::_srai(const Input &input) {
    dtype shift_amount = _getRequestedSource(input);
    dtype result = input.operand1 >> shift_amount;
    // Data is unsigned, so the sign should be handled manually
    dtype MSB = (input.operand1 & 0x80000000);
    if (MSB != 0) {
        dtype sign_ext_mask = ((dtype) -1) & ~((MSB >> shift_amount) - 1);
        result |= sign_ext_mask;
    }
    return Output{result};
}

ALU::InputFormatError::InputFormatError(const std::string &msg) : std::runtime_error(msg) {}
