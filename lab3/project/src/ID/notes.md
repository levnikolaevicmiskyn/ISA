# ID STAGE #

## Input ports: ##

ID_inst (32 bits)	: instruction from IF stage
ID_pc (32 bits)	: program counter
ID_next_pc (32 bits): output of the incrementer (pc+4)
EX_rd_bw: Destination register coming from the ID/EX pipeline register (backward)
EX_mem_read_bw: Mem read signal taken from ID/EX pipeline register (backward)
ID_misprediction: Signal coming from the EX stage, it is true when a misprediction occurred.
WB_reg_write_bw: Register file write enable coming from the MEM/WB pipeline Register
WB_rd_bw: Destination register coming from MEM/WB pipeline register
WB_data: Data coming from MEM_WB pipeline register

reg_write: 		: enable signal to write register file, from MEM/WB pipeline register

ID_EX_mem_read  : mem_read signal from ID_EX pipeline register


## Output ports: ##

# EX stage #
alu_op: Signal of type t_ALU_OP (enum, defined globally) that encodes the operation to be performed by the alu.
		Its value is one of the following: * alu_op_shift, alu_op_add, alu_op_xor, alu_op_and, alu_op_nop, alu_op_lt, alu_op_inc_4 *.

alu_use_immediate: This is true when the second operand of the adder is the immediate rather than <rs2>

alu_oprnd_1, alu_oprnd_2 (32 bits): ALU operands as fetched from the register file.

alu_immediate (32 bits): Sign-extended immediate value

EX_load_nop: Replace control signals with a nop instead of forwarding them to the EX/MEM pipeline register

# IF stage #
IF_load_jmp_addr: PC must be loaded with jump address coming from ID STAGE
** IF_stall **: If this is set, do not increment the program counter and do not update
								IF/ID pipeline register!
** IF_load_nop **: If this is set, load a nop instruction (addi x0, x0, 0) in the IF/ID pipeline Register
IF_jmp_addr: The value of the target address to be loaded in PC

# MEM stage #
mem_write		: write to memory
mem_read		: read from memory
MEM_load_nop: replace control signals with a nop instead of forwarding them to MEM/WB pipeline register

# WB stage #
wb_mem_to_reg 	: omitted because it is the same as mem_read
wb_reg_write 	: Enables writing to the register file

# IF stage #
IF_stall: if this signal is active, do not update the IF/ID pipeline register and
					do not update PC
IF_pc_sel: it can be


## In case of load-use data hazard ##
This is detected by an hazard detection unit. Current instruction is replaced by alu_op_nop
by the instruction decoding unit (* instDecoder *) which sets * IF_stall * to 1.
The IF stage should not increment the program counter (load it with its previous value)
and it should not update the IF/ID pipeline register, which must retain its value. This is equivalent
to re-fetching the old instruction.

## In case of jump ##
As soon as a jump instruction is decoded, the internal flag * jump * is set. This
causes * IF_load_jmp_addr * and * IF_load_nop * to be asserted.

## In case of branch ##

## In case of misprediction ##
