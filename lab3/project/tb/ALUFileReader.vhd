library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity ALUFileReader is
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
end entity ALUFileReader;

architecture behavior of ALUFileReader is
begin
    proc_dataReader: process(clk)
        file samplefile: text open READ_MODE is filename;
        variable linein: line;
        variable tmp_opcode: std_logic_vector(3 downto 0);
        variable tmp_operand1: std_logic_vector(31 downto 0);
        variable tmp_operand2: std_logic_vector(31 downto 0);
        variable tmp_immediate: std_logic_vector(31 downto 0);
        variable tmp_source: std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            if en = '1' then
                if not endfile(samplefile) then
                    readline(samplefile, linein);
                    hread(linein, tmp_opcode);
                    hread(linein, tmp_operand1);
                    hread(linein, tmp_operand2);
                    hread(linein, tmp_immediate);
                    hread(linein, tmp_source);
                    opcode <= tmp_opcode(2 downto 0);
                    operand1 <= tmp_operand1;
                    operand2 <= tmp_operand2;
                    immediate <= tmp_immediate;
                    source <= tmp_source(0);
                end if;
            end if;
        end if;
    end process proc_dataReader;
end architecture behavior;
