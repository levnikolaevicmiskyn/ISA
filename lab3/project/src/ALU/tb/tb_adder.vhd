library ieee;
use ieee.std_logic_1164.all;

entity tb_adder is
end entity tb_adder;

architecture behavior of tb_adder is
    component adder is
        generic (N : positive := 32);
        port (
            a: in  std_logic_vector(N-1 downto 0);
            b: in  std_logic_vector(N-1 downto 0);
            cin: in std_logic;
            s: out std_logic_vector(N-1 downto 0);
            cout: out std_logic
        );
    end component;

    component ALUFileReader is
        generic (
            filename: string
        );
        port (
            clk: in std_logic;
            en: in std_logic;
            opcode: out std_logic_vector(2 downto 0);
            operand1: out std_logic_vector(31 downto 0);
            operand2: out std_logic_vector(31 downto 0);
            immediate: out std_logic_vector(31 downto 0);
            source: out std_logic
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

    component dataSink is
        generic (
            N: positive;
            filename: string
        );
        port (
            clk: in std_logic;
            en: in std_logic;
            data: in std_logic_vector(N-1 downto 0)
        );
    end component;

    signal clk: std_logic;
    signal operand1, operand2: std_logic_vector(31 downto 0);
    signal result: std_logic_vector(31 downto 0);
    signal en_write_file: std_logic;
begin
    en_write_file <= '0', '1' after 10 ns;
    comp_clkGen: clockGenerator
        generic map (0 ns)
        port map ('1', open, clk);

    comp_fileReader: ALUFileReader
        generic map("inputs.txt")
        port map(clk, '1', open, operand1, operand2, open, open);

    comp_adder: adder
        generic map(32)
        port map(operand1, operand2, '0', result, open);
    
    comp_fileWriter: dataSink
        generic map(32, "results.txt")
        port map(clk, en_write_file, result);
end architecture behavior;
