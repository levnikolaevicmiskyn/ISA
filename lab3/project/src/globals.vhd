library ieee;

package globals is
	type t_ALU_OP is (alu_op_shift, alu_op_add, alu_op_xor, alu_op_and, alu_op_nop, alu_op_lt, alu_op_inc_4);
	constant PC_SEL_JUMP: std_logic_vector(1 downto 0) := "10";
	constant PC_SEL_STALL: std_logic_vector(1 downto 0) := "01";
	constant PC_SEL_INC: std_logic_vector(1 downto 0) := "00";
end package globals;