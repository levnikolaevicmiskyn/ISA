library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;


library std;
use std.textio.all;

entity dataGen is
	generic(NB : INTEGER := 8);
	port(clk, rst_n : in std_logic;
		data_out : out signed(NB-1 downto 0);
		end_sim, vout: out std_logic
	);
end dataGen;

architecture behavior of dataGen is
constant tco : time := 1 ns; -- Clock to output delay
signal end_sim_s : std_logic;
signal end_sim_v : std_logic_vector(10 downto 0);
signal hangon : std_logic := '1'; -- This flag is true right after asynchronous reset, causes a delay of one clock cycle to for the DUT to reset synchronously.

begin
fetch_proc: process (clk, rst_n)
	file samplefile : text open READ_MODE is "samples.txt";
	variable linein : line;
	variable x : integer;
begin
	if rst_n = '0' then
		data_out <= (others => '0') after tco;
		vout <= '0' after tco;
		end_sim_s <= '0' after tco;
		hangon <= '1';
	elsif rising_edge(clk) then
		if hangon = '1' then
			hangon <= '0';
		elsif not endfile(samplefile) then
			readline(samplefile, linein); -- Read a new line from the input file
			read(linein, x); -- Interpret the text line as an integer and store it in xn
			data_out <= to_signed(x, data_out'LENGTH) after tco;
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