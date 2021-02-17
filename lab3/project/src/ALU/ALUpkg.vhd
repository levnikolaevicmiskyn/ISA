library ieee;
use ieee.std_logic_1164.all;

package ALUpkg is
    -- Input selections
    subtype t_InputSelector is std_logic_vector(2 downto 0);
    constant SEL_ZERO:      t_InputSelector := "000";
    constant SEL_OPERAND:   t_InputSelector := "100";
    constant SEL_CONST:     t_InputSelector := "011";
    constant SEL_SPECIAL:   t_InputSelector := "010";
    constant SEL_FWD_MEM:   t_InputSelector := "110";
    constant SEL_FWD_WB:    t_InputSelector := "101";
    constant SEL_OTHER:     t_InputSelector := "110";
    -- Internal perations
    subtype t_InternalOperation is std_logic_vector(2 downto 0);
    constant OP_SUM:    t_InternalOperation := "001";
    constant OP_SHIFT:  t_InternalOperation := "000";
    constant OP_AND:    t_InternalOperation := "011";
    constant OP_XOR:    t_InternalOperation := "010";
    constant OP_COMP:   t_InternalOperation := "100";
    -- Control
    subtype t_Comparison is std_logic_vector(2 downto 0);
    constant COMP_LT: t_Comparison := "000";
    constant COMP_LE: t_Comparison := "001";
    constant COMP_EQ: t_Comparison := "010";
    constant COMP_GE: t_Comparison := "011";
    constant COMP_GT: t_Comparison := "100";

    type t_OperandInfo is record
        negative: std_logic;
    end record;
    
    type t_Control is record
        operation: t_InternalOperation;
        adder_sub: std_logic;
        comp_signed_data: std_logic;
        comp_comparison: t_Comparison;
    end record;
end package ALUpkg;
