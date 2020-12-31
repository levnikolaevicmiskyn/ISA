library ieee;
use ieee.std_logic_1164.all;

entity ALUController is
    port (
        op: in t_ALU_OP;
        sel_immediate: in std_logic;
        sel_pc: in std_logic;

        sel_operand1: out std_logic_vector(1 downto 0);
        sel_operand2: out std_logic_vector(1 downto 0);
        ALU_control: out std_logic_vector(2 downto 0)
    );
end entity ALUController;

architecture structure of ALUController is
    signal ALU_adder_sub: std_logic;
    signal ALU_sel_result: std_logic_vector(1 downto 0);
begin
    proc_controller: process(op, sel_immediate, sel_pc)
    begin
        ALU_adder_sub <= '0';
        ALU_sel_result <= "00"
        sel_operand1 <= '0' & sel_pc;
        sel_operand2 <= '0' & sel_immediate;
        case op is
            when alu_op_nop =>
                -- Set operand1 to zero
                sel_operand1 <= "10";
            when alu_op_add =>
            when alu_op_shift =>
                ALU_sel_result <= "01";
            when alu_op_and =>
                ALU_sel_result <= "10";
            when alu_op_xor =>
                ALU_sel_result <= "11";
            when alu_op_lt =>
                ALU_adder_sub <= '1';
            when others =>
        end case;
    end proc_controller;

    control <= ALU_adder_sub & ALU_sel_result;
end architecture structure;
