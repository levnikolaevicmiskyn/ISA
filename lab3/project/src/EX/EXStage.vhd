library ieee;
use ieee.std_logic_1164.all;

library work;
use work.globals;
use work.ALUpkg;

entity EXStage is
    port (
        ex_sigs: in globals.t_EXSigs;    -- Stage control signals and numerical operands
        fwd_sigs: in globals.t_FWDSigs;  -- Control signals and data from the FWD unit
        ex_data: out globals.t_EXData    -- Results
    );
end entity EXStage;

architecture structure of EXStage is
    component EXController is
        port (
            instruction_type: in globals.t_ALUOperandsType;
            sel_forward1: in std_logic_vector(1 downto 0);
            sel_forward2: in std_logic_vector(1 downto 0);

            sel_operand1: out ALUpkg.t_InputSelector;
            sel_operand2: out ALUpkg.t_InputSelector
        );
    end component;

    component ALU is
        port (
            -- Control signals
            operation: globals.t_ALU_OP;
            -- Operands and result
            operand1: in std_logic_vector(31 downto 0);     -- First operand
            operand2: in std_logic_vector(31 downto 0);     -- Second operand
            result: out std_logic_vector(31 downto 0);      -- Result
            -- Flags
            N: out std_logic;   -- Negative flag
            Z: out std_logic;   -- Zero flag
            C: out std_logic;   -- Carry out flag
            V: out std_logic    -- Overflow flag
        );
    end component;

    signal operand1: std_logic_vector(31 downto 0);
    signal operand2: std_logic_vector(31 downto 0);

    -- Why not := std_logic(to_unsigned(0, 32)) or similar? Because I like it more this way... too bad!
    constant CONST_ZERO: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    constant CONST_4:    std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

    signal sel_operand1: ALUpkg.t_InputSelector;
    signal sel_operand2: ALUpkg.t_InputSelector;
begin
    comp_controller: EXController
        port map (
            ex_sigs.oprnd_sel,
            fwd_sigs.sel_forward1,
            fwd_sigs.sel_forward2,
            sel_operand1,
            sel_operand2
        );
    -- Select inputs
    with sel_operand1 select operand1 <=
         CONST_ZERO           when ALUpkg.SEL_ZERO,
         ex_sigs.oprnd_1     when ALUpkg.SEL_OPERAND,
         CONST_ZERO           when ALUpkg.SEL_CONST,
         ex_sigs.pc           when ALUpkg.SEL_SPECIAL,
         fwd_sigs.MEM_data    when ALUpkg.SEL_FWD_MEM,
         fwd_sigs.WB_data     when ALUpkg.SEL_FWD_WB,
         (31 downto 0 => 'X') when others;
    with sel_operand2 select operand2 <=
         CONST_ZERO           when ALUpkg.SEL_ZERO,
         ex_sigs.oprnd_2     when ALUpkg.SEL_OPERAND,
         CONST_4              when ALUpkg.SEL_CONST,
         ex_sigs.immediate    when ALUpkg.SEL_SPECIAL,
         fwd_sigs.MEM_data    when ALUpkg.SEL_FWD_MEM,
         fwd_sigs.WB_data     when ALUpkg.SEL_FWD_WB,
         (31 downto 0 => 'X') when others;

    comp_ALU: ALU
        port map(ex_sigs.op, operand1, operand2, ex_data.result, ex_data.N, ex_data.Z, ex_data.C, ex_data.V);
end architecture structure;
