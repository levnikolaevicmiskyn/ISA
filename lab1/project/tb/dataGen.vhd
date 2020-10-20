library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;


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
signal hangon : std_logic := '1'; -- This flag is true right after asynchronous reset, it causes a delay of one clock cycle for the DUT to reset synchronously.

signal counter: integer := 0;

begin
fetch_proc: process (clk, rst_n)
	file samplefile : text open READ_MODE is "samples.txt";
	file timingfile : text open READ_MODE is "in_timing.txt";
	variable linein : line;
	variable x: integer;
	variable factor : integer;
	variable timing_linein : line; 
begin
	if rst_n = '0' then
		data_out <= (others => '0') after tco;
		vout <= '0' after tco;
		end_sim_s <= '0' after tco;
		-- Set the hang on flag to 1
		hangon <= '1';
		-- Set the clock cycle counter to 0
		counter <= 0;
	elsif rising_edge(clk) then
		if hangon = '1' then
			-- Get here in the first clock cycles after the asynchronous reset has been deasserted, during the reset cycle of 
			-- the DUT. Set the hang on flag to 0 and fetch the time instant when the first sample is to be issued 
			hangon <= '0';
			
			readline(timingfile, timing_linein);
			read(timing_linein, factor);
		else
			counter <= counter + 1;
			if endfile(samplefile) then
				vout <= '0' after tco;
				end_sim_s <= '0' after tco;
			elsif counter mod factor = 0 then
			-- Get here if the next sample is to be issued.
				if not endfile(samplefile) then
					readline(samplefile, linein); -- Read a new line from the input file
					read(linein, x); -- Interpret the text line as an integer and store it in xn
					data_out <= to_signed(x, data_out'LENGTH) after tco;
					vout <= '1' after tco;
				end if;
			else
				-- Get here if the end of file the samples file has not been reached
				-- and no new sample must be given as input in the current clock cycle.
				vout <= '0';
			end if;
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
