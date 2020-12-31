library ieee;
use ieee.std_logic_1164.all;

entity EXEStage is
    port (
        -- Opcode
        op: in t_ALU_OP;
        -- Data
        operand1:  in std_logic_vector(31 downto 0);  -- Operand 1
        operand2:  in std_logic_vector(31 downto 0);  -- Operand 2
        next_pc:   in std_logic_vector(31 downto 0);  -- Next PC
        immediate: in std_logic_vector(31 downto 0);  -- Immediate
        MEM_data:  in std_logic_vector(31 downto 0);  -- Forward from MEM stage
        WB_data:   in std_logic_vector(31 downto 0);  -- Forward from WB stage
        -- External mux controllers
        sel_forward1: in std_logic_vector(1 downto 0);
        sel_forward2: in std_logic_vector(1 downto 0);
        sel_immediate: in std_logic;
        sel_pc: in std_logic;

        result: out std_logic_vector(31 downto 0);  -- Final result
        N: out std_logic;   -- Negative flag
        Z: out std_logic;   -- Zero flag
        C: out std_logic;   -- Carry flag
        V: out std_logic    -- Overflow flag
    );
end entity EXEStage;

architecture structure of EXEStage is
    component ALU is
        port (
            -- Operands and result
            operand1: in std_logic_vector(31 downto 0);     -- First operand
            operand2: in std_logic_vector(31 downto 0);     -- Second operand
            result: out std_logic_vector(3 downto 0);       -- Result
            -- Control signals
            control: in std_logic;                          -- Control signals
            sel_result: in std_logic_vector(1 downto 0);    -- Result selection
            -- Flags
            N: out std_logic;   -- Negative flag
            Z: out std_logic;   -- Zero flag
            C: out std_logic;   -- Carry out flag
            V: out std_logic    -- Overflow flag
        );
    end component;

    component ALUController is
        port (
            op: in t_ALU_OP;
            sel_immediate: in std_logic;
            sel_pc: in std_logic;

            sel_operand1: out std_logic_vector(1 downto 0);
            sel_operand2: out std_logic_vector(1 downto 0);
            ALU_control: out std_logic_vector(2 downto 0)
        );
    end component;

    signal control: std_logic;
    -- Selection signals
    signal sel_a: std_logic_vector(1 downto 0);
    signal sel_b: std_logic_vector(1 downto 0);
    -- Operands pre-forwarding
    signal temp_a: std_logic_vector(31 downto 0);
    signal temp_b: std_logic_vector(31 downto 0);
    -- Final operands
    signal a: std_logic_vector(31 downto 0);
    signal b: std_logic_vector(31 downto 0);
begin
    -- Controller
    comp_controller: ALUController
        port map (op, sel_immediate, sel_pc, control, sel_a, sel_b);
    -- Selection of the inputs
    with sel_a select temp_a <=
        operand1 when "00",
        next_pc when "01",
        (31 downto 0 => '0') when "10",
        (31 downto 0 => 'X') when others;
    with sel_b select temp_b <=
        operand2 when "00",
        immediate when "01",
        (31 downto 0 => '0') when "10",
        (31 downto 0 => 'X') when others;
    with sel_forward1 select a <=
        temp_a when "00",
        MEM_data when "10",
        WB_data when "01",
        (31 downto 0 => 'X') when others;
    with sel_forward2 select b <=
        temp_b when "00",
        MEM_data when "10",
        WB_data when "01",
        (31 downto 0 => 'X') when others;
    -- Instantiate ALU
    com_ALU: ALU
        port map (a, b, result, control, sel_result, N, Z, C, V);
end architecture structure;
