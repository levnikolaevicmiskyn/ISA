library ieee;
use ieee.std_logic_1164.all;

library work;
use work.globals;
use work.ALUpkg;

entity tb_ALU is
end entity tb_ALU;

architecture behavior of tb_ALU is
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

    component ALUFileReader is
        generic (
            filename: string
        );
        port (
            clk: in std_logic;
            en: in std_logic;
            done: out std_logic;
            operand1: out std_logic_vector(31 downto 0);
            operand2: out std_logic_vector(31 downto 0);
            operation: out globals.t_ALU_OP
        );
    end component;

    component ALUFileWriter is
        generic (filename: string);
        port (
            clk: in std_logic;
            en: in std_logic;
            result: in std_logic_vector(31 downto 0);
            N: in std_logic;
            Z: in std_logic;
            C: in std_logic;
            V: in std_logic
        );
    end component;

    component clockGenerator is
        generic (
            RESET_DURATION: time
        );
        port (
            en: in std_logic;
            rst_n: out std_logic;
            clk: out std_logic
        );
    end component;

    signal clk: std_logic;
    signal operand1: std_logic_vector(31 downto 0);
    signal operand2: std_logic_vector(31 downto 0);
    signal operation: globals.t_ALU_OP;
    signal result: std_logic_vector(31 downto 0);
    signal done: std_logic;
    signal rst_n: std_logic;
    signal wr: std_logic;
    signal N, Z, C, V: std_logic;

begin
    wr <= (not done) and rst_n;
    comp_clkGen: clockGenerator
        generic map (1 ns)
        port map ('1', rst_n, clk);

    comp_ALUFileReader: ALUFileReader
        generic map ("inputs.txt")
        port map (clk, '1', done, operand1, operand2, operation);

    comp_ALU: ALU
        port map (operand1, operand2, result, control, N, Z, C, V);

    comp_ALUFileWriter: ALUFileWriter
        generic map ("results-VHDL.txt")
        port map(clk, wr, result, N, Z, C, V);
end architecture behavior;
