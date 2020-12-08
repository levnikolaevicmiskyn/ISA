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
        variable iopcode: integer;
        variable ioperand1: integer;
        variable ioperand2: integer;
        variable iimmediate: integer;
        variable isource: integer;
    begin
        if rising_edge(clk) then
            if en = '1' then
                if not endfile(samplefile) then
                    readline(samplefile, linein);
                    read(linein, iopcode);
                    read(linein, ioperand1);
                    read(linein, ioperand2);
                    read(linein, iimmediate);
                    read(linein, isource);
                    opcode <= std_logic_vector(to_unsigned(iopcode, 32));
                    operand1 <= std_logic_vector(to_unsigned(ioperand1, 32));
                    operand2 <= std_logic_vector(to_unsigned(ioperand2, 32));
                    immediate <= std_logic_vector(to_unsigned(iimediate, 32));
                    source <= to_unsigned(isource, 1)(0);
                end if;
            end if;
        end if;
    end process proc_dataReader;
end architecture behavior;
