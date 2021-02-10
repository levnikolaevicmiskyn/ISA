library ieee;
use ieee.std_logic_1164.all;

library work;
use work.globals;
use work.ALUpkg;

entity ALUController is
    port (
        operation: in globals.t_ALU_OP;  -- ALU abstract operation
        operand1_info: in ALUpkg.t_OperandInfo; -- Operand 1 info
        operand2_info: in ALUpkg.t_OperandInfo; -- Operand 2 info
        control: out ALUpkg.t_Control    -- Control signals
    );
end entity ALUController;

architecture structure of ALUController is
begin
    proc_control: process(operation, operand1_info, operand2_info)
    begin
        control.operation <= ALUpkg.OP_SUM;
        control.adder_sub <= '0';
        control.comp_signed_data <= '1';
        control.comp_comparison <= ALUpkg.COMP_LT;
        case operation is
            when globals.alu_op_add =>
                control.operation <= ALUpkg.OP_SUM;
                control.adder_sub <= '0';
            when globals.alu_op_shift =>
                control.operation <= ALUpkg.OP_SHIFT;
            when globals.alu_op_abs =>
                control.operation <= ALUpkg.OP_SUM;
                if operand2_info.negative = '1' then
                    control.adder_sub <= '1';
                else
                    control.adder_sub <= '0';
                end if;
            when globals.alu_op_and =>
                control.operation <= ALUpkg.OP_AND;
            when globals.alu_op_xor =>
                control.operation <= ALUpkg.OP_XOR;
            when globals.alu_op_lt =>
                control.operation <= ALUpkg.OP_COMP;
                control.adder_sub <= '1';
                control.comp_signed_data <= '1';
                control.comp_comparison <= ALUpkg.COMP_LT;
            when others =>
                assert false
                report "Unknown ALU operation requested"
                severity error;
        end case;
    end process proc_control;
end architecture structure;
