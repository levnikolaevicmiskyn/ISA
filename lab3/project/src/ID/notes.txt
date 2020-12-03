# ID STAGE #

## Input ports: ##

inst (32 bits)	: instruction from IF stage
pc (32 bits)	: program counter
reg_write: 		: enable signal to write register file, from MEM/WB pipeline register

ID_EX_mem_read  : mem_read signal from ID_EX pipeline register


## Output ports: ##

# EX stage #
alu_op: Signal of type t_ALU_OP (enum, defined globally) that encodes the operation to be performed by the alu.
		Its value is one of the following: * alu_op_shift, alu_op_add, alu_op_xor, alu_op_and, alu_op_nop, alu_op_lt, alu_op_inc_4 *.
		
alu_use_immediate: This is true when the second operand of the adder is the immediate rather than <rs2>

alu_oprnd_1, alu_oprnd_2 (32 bits): ALU operands as fetched from the register file.

# IF stage #
IF_ID_write_n	: write enable for IF/ID pipeline register, active low
PC_write_n		: do not update PC when this signal is 1

# MEM stage #
mem_write		: write to memory
mem_read		: read from memory

# WB stage #
wb_mem_to_reg 	: omitted because it is the same as mem_read
wb_reg_write 	: Enables writing to the register file