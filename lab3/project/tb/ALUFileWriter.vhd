library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity ALUFileWriter is
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
end entity ALUFileWriter;

architecture behavior of ALUFileWriter is
begin
    proc_writeData: process(clk)
        file resultfile: text open WRITE_MODE is filename;
        variable lineout: line;
    begin
        if rising_edge(clk) then
            if en = '1' then
                hwrite(lineout, result);
                hwrite(lineout, N);
                hwrite(lineout, Z);
                hwrite(lineout, C);
                hwrite(lineout, V);
                writeline(resultfile, lineout);
            end if;
        end if;
    end process proc_writeData;
end architecture behavior;
