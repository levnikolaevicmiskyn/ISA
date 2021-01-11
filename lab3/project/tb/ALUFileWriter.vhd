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
	variable tmp_N: std_logic_vector(3 downto 0) := "000U";
	variable tmp_Z: std_logic_vector(3 downto 0) := "000U";
	variable tmp_C: std_logic_vector(3 downto 0) := "000U";
	variable tmp_V: std_logic_vector(3 downto 0) := "000U";
    begin
        if rising_edge(clk) then
            if en = '1' then
                tmp_N(0) := N;
                tmp_Z(0) := Z;
                tmp_C(0) := C;
                tmp_V(0) := V;
                hwrite(lineout, result);
                -- write(lineout, ' ');
                -- hwrite(lineout, tmp_N);
                -- write(lineout, ' ');
                -- hwrite(lineout, tmp_Z);
                -- write(lineout, ' ');
                -- hwrite(lineout, tmp_C);
                -- write(lineout, ' ');
                -- hwrite(lineout, tmp_V);
                writeline(resultfile, lineout);
            end if;
        end if;
    end process proc_writeData;
end architecture behavior;
