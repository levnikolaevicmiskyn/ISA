library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;


entity DataGen is
	generic(N : positive := 32);
	port(
			clk			: in std_logic;
			data_out	: out std_logic_vector(N-1 downto 0)
		);
end entity DataGen;

architecture behavioral of DataGen is
	constant tco : time := 1 ns; -- Clock to output delay
	constant filename : string := "fp_samples.hex";

begin

	fetch_proc: process(clk)
		file samplefile : text open READ_MODE is filename;
		variable linein : line;
		variable x: std_logic_vector(N-1 downto 0);
		
	begin
		if rising_edge(clk) then
			if not endfile(samplefile) then
					readline(samplefile, linein); -- Read a new line from the input file
					hread(linein, x); -- Interpret the text line as an integer and store it in xn
					data_out <= x after tco;
			end if;
		end if;
	end process;
	

end architecture behavioral;
