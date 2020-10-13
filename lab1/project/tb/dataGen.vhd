library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity dataGen is
	generic(NB : INTEGER := 8);
	port(clk, rst_n : in std_logic;
		data_out : in signed(NB-1 downto 0);
		end_sim, vout: out std_logic
	);
end dataGen;

architecture behavior of dataGen is
begin

constant tco : time := 1 ns -- Clock to output delay
signal end_sim_s : std_logic;
signal end_sim_v : std_logic_vector(9 downto 0);

fetch_proc: process (clk, rst_n)
	file samplefile : text open READ_MODE is "samples.txt";
	variable linein : line;
	variable x : integer;
begin
	if rst_n = '0' then
		dout <= (others => '0') after tco;
		vout <= '0' after tco;
		end_sim_s <= '0' after tco;
	elsif rising_edge(clk) then
		if not endfile(samplefile) then
			readline(samplefile, linein); -- Read a new line from the input file
			read(linein, x); -- Interpret the text line as an integer and store it in xn
			data_out <= std_logic_vector(to_unsigned(x, x'LENGTH)) after tco;
			vout <= '1' after tco;
		else
			vout <= '0' after tco;
			end_sim_s <= '1' after tco;
		end if;
	end if;
end process;

process(clk, rst_n)
begin
	if rst_n = '0' then
		end_sim_v <= (others => '0') after tco;
	elsif rising_edge(clk) then
		for i in end_sim_v'length - 1 downto 1 loop
			end_sim_v(i-1) <= end_sim_v(i);
		end loop;
		end_sim_v(0) <= end_sim_s;
	end if;
end process;

end_sim <= end_sim_v(10);

end behavior;