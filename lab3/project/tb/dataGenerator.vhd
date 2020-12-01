library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity dataGenerator is
    generic (
        N: positive;
        filename: string
    );
    port (
        clk: in std_logic;
        en: in std_logic;
        data: out std_logic_vector(N-1 downto 0)
    );
end entity dataGenerator;

architecture behavior of dataGenerator is
begin
    proc_dataReader: process(clk)
        file samplefile: text open READ_MODE is filename;
        variable linein: line;
        variable x: integer;
    begin
        if rising_edge(clk) then
            if en = '1' then
                if not endfile(samplefile) then
                    readline(samplefile, linein);
                    read(linein, x);
                    data <= std_logic_vector(to_signed(x, N));
                end if;
            end if;
        end if;
    end process proc_dataReader;
end architecture behavior;
