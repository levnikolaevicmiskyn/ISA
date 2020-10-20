library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity dataSink is
	generic(NB : integer := 8);
	port (clk, rst_n: in std_logic;
		  vin, vout: in std_logic;
		  din: in signed(NB-1 downto 0));
end dataSink;


architecture behavior of dataSink is
signal vin_dline: STD_LOGIC_VECTOR(1 downto 0);
begin
	process(clk, rst_n)
		file results_file : text open WRITE_MODE is "results-VHDL.txt";
		variable outline : line;
	begin
		if rst_n = '0' then
			-- Do nothing
		elsif rising_edge(clk) then
			if vout = '1' then
				write(outline, to_integer(din));
				writeline(results_file, outline);
			end if;
			
			-- Issue a warning when VOUT goes high unexpectedly. This is detected by XORing the VOUT bit with its expected value at the end
			-- of the delay line vin_dline(0)
			assert (vout xor vin_dline(0)) = '0' report "VOUT has been asserted unexpectedly at time " & time'image(now) severity warning;
		end if;
	end process;
	
	
	vsig_sh_reg: process(clk, rst_n)
	begin
		if rst_n = '0' then
			vin_dline <= (others => '0');
		elsif rising_edge(clk) then
			vin_dline(vin_dline'length-1) <= vin;
			for i in vin_dline'length-1 downto 1 loop
				vin_dline(i-1) <= vin_dline(i);
			end loop;
		end if;
	end process;
end behavior;
