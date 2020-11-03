library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity DataSink is
	generic(N : positive := 32);
	port(
			clk 	: in std_logic;
			din		: std_logic_vector(N-1 downto 0)
		);
end DataSink;

architecture behavioral of DataSink is
	constant filename : string := "results.hex";

begin
	sink_proc: process(clk)
		file results_file : text open WRITE_MODE is filename;
		variable outline : line;
	begin
		if rising_edge(clk) then
			if not is_x(din) then
				hwrite(outline, din);
				writeline(results_file, outline);
			end if;
		end if;
	end process;

end architecture behavioral; 
