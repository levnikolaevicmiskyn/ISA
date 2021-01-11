library ieee;
use ieee.std_logic_1164.all;

library work;
use work.globals.all;
use work.ALUpkg;

entity EXController is
    port (
        instruction_type: in t_ALUInstructionType;
        sel_forward1: in std_logic_vector(1 downto 0);
        sel_forward2: in std_logic_vector(1 downto 0);

        sel_operand1: out ALUpkg.t_InputSelector;
        sel_operand2: out ALUpkg.t_InputSelector
    );
end entity EXController;

architecture structure of EXController is
begin
    proc_op1_selector: process(instruction_type, sel_forward1)
        variable tmp_sel: ALUpkg.t_InputSelector;
    begin
        case instruction_type is
            when alu_sel_reg_reg => tmp_sel := ALUpkg.SEL_OPERAND;
            when alu_sel_reg_imm => tmp_sel := ALUpkg.SEL_OPERAND;
            when alu_sel_pc_imm  => tmp_sel := ALUpkg.SEL_SPECIAL;
            when alu_sel_pc_4    => tmp_sel := ALUpkg.SEL_SPECIAL;
            when alu_sel_0_imm   => tmp_sel := ALUpkg.SEL_ZERO;
            when alu_sel_0_0     => tmp_sel := ALUpkg.SEL_ZERO;
            when others          => tmp_sel := ALUpkg.SEL_ZERO;
        end case;
        -- If a register was selected, consult FWD unit:
        if tmp_sel = ALUpkg.SEL_OPERAND then
            case sel_forward1 is
                when "00"   => tmp_sel := ALUpkg.SEL_OPERAND;
                when "01"   => tmp_sel := ALUpkg.SEL_FWD_MEM;
                when "10"   => tmp_sel := ALUpkg.SEL_FWD_WB;
                when others => tmp_sel := ALUpkg.SEL_ZERO;
            end case;
        end if;
        -- Assign to selector
        sel_operand1 <= tmp_sel;
    end process proc_op1_selector;

    proc_op2_selector: process(instruction_type, sel_forward2)
        variable tmp_sel: ALUpkg.t_InputSelector;
    begin
        case instruction_type is
            when alu_sel_reg_reg => tmp_sel := ALUpkg.SEL_OPERAND;
            when alu_sel_reg_imm => tmp_sel := ALUpkg.SEL_SPECIAL;
            when alu_sel_pc_imm  => tmp_sel := ALUpkg.SEL_SPECIAL;
            when alu_sel_pc_4    => tmp_sel := ALUpkg.SEL_CONST;
            when alu_sel_0_imm   => tmp_sel := ALUpkg.SEL_SPECIAL;
            when alu_sel_0_0     => tmp_sel := ALUpkg.SEL_ZERO;
            when others          => tmp_sel := ALUpkg.SEL_ZERO;
        end case;
        -- If a register was selected, consult FWD unit:
        if tmp_sel = ALUpkg.SEL_OPERAND then
            case sel_forward2 is
                when "00"   => tmp_sel := ALUpkg.SEL_OPERAND;
                when "01"   => tmp_sel := ALUpkg.SEL_FWD_MEM;
                when "10"   => tmp_sel := ALUpkg.SEL_FWD_WB;
                when others => tmp_sel := ALUpkg.SEL_ZERO;
            end case;
        end if;
        -- Assign to selector
        sel_operand2 <= tmp_sel;
    end process proc_op2_selector;
end architecture structure;
