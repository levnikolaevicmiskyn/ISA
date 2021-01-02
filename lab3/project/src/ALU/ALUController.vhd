library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALUpkg;

entity ALUController is
    port (
        operation: in t_ALU_OP;         -- ALU abstract operation
        control: out ALUpkg.t_Control   -- Control signals
    );
end entity ALUController;

architecture structure of ALUController is
begin
    proc_control: process(operation)
    begin
        control.operation <= ALUpkg.OP_SUM;
        control.adder_sub <= '0';
        control.comp_signed_data <= '1';
        control.comp_comparison <= ALUpkg.COMP_LT;
        case operation is
            when alu_op_add =>
                control.operation <= ALUpkg.OP_SUM;
                control.adder_sub <= '0';
            when alu_op_shift =>
                control.operation <= ALUpkg.OP_SHIFT;
            when alu_op_and =>
                control.operation <= ALUpkg.OP_AND;
            when alu_op_xor =>
                control.operation <= ALUpkg.OP_XOR;
            when alu_op_lt =>
                control.operation <= ALUpkg.OP_COMP;
                control.comp_signed_data <= '1';
                control.comp.comparison <= ALUpkg.COMP_LT;
            when others =>
                assert false
                report "Unknown ALU operation requested"
                severity error;
        end case;
    end process proc_control;
end architecture structure;
