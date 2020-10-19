library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity dataSink is
	generic(NB : integer := 8);
	port (clk, rst_n: in std_logic;
		  vin: in std_logic;
		  din: in signed(NB-1 downto 0));
end dataSink;


architecture behavior of dataSink is

begin
	process(clk, rst_n)
		file results_file : text open WRITE_MODE is "results-VHDL.txt";
		variable outline : line;
	begin
		if rst_n = '0' then
			-- Do nothing
		elsif rising_edge(clk) then
			if VIN = '1' then
				write(outline, to_integer(din));
				writeline(results_file, outline);
			end if;
		end if;
	end process;
end behavior;
