library ieee;
use ieee.std_logic_1164.all;

package globals is
	type t_ALU_OP is (alu_op_shift, alu_op_add, alu_op_xor, alu_op_and, alu_op_nop, alu_op_lt, alu_op_inc_4);
	constant PC_SEL_JUMP: std_logic_vector(1 downto 0) := "10";
	constant PC_SEL_STALL: std_logic_vector(1 downto 0) := "01";
	constant PC_SEL_INC: std_logic_vector(1 downto 0) := "00";

	function getOp(signal x: in std_logic_vector(2 downto 0)) return t_ALU_OP;
end package globals;

package body globals is
	function getOp(signal x: in std_logic_vector(2 downto 0)) return t_ALU_Op is
		variable y: t_ALU_OP;
		begin
			case x is
				when "" => y := alu_op_shift
				when "" =>y :=alu_op_add
				when "" =>y :=alu_op_xor
				when "" =>y :=alu_op_and
				when "" =>y :=alu_op_nop
				when "" =>y :=alu_op_lt
				when others => y :=alu_op_inc_4
			end case;
			return y;
	end function getOp;
end package body;
