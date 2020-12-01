library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity dataSink is
    generic (
        N: positive;
        filename: string
    );
    port (
        clk: in std_logic;
        en: in std_logic;
        data: in std_logic_vector(N-1 downto 0)
    );
end entity dataSink;

architecture behavior of dataSink is
begin
    proc_dataReader: process(clk)
        file results_file: text open WRITE_MODE is filename;
        variable lineout: line;
    	variable x: integer;
    begin
        if rising_edge(clk) then
            if en = '1' then
                write(lineout, to_integer(signed(data)));
				writeline(results_file, lineout);
            end if;
        end if;
    end process proc_dataReader;
end architecture behavior;
