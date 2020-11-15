library ieee;
use ieee.std_logic_1164.all;

entity controlUnit is
	port(clk, rst_n, VIN: in std_logic;
		VOUT: out std_logic;
		clr_delay_regs, en_latch, en_regs: out std_logic
		);
end entity controlUnit;


architecture JLookAhead of controlUnit is
constant NPIPE: integer := 3;
signal token_dline: std_logic_vector(2+NPIPE-1 downto 0);
begin
proc_delay_line: process(clk)
	begin
		if rising_edge(clk) then
			if rst_n='0' then
				token_dline <= (OTHERS => '0');
			else
				token_dline(token_dline'length-2 downto 0) <= token_dline(token_dline'length-1 downto 1);
				token_dline(token_dline'length-1) <= VIN;
			end if;
		end if;
	end process;
	
proc_rst_reg: process(clk)
begin
	if rising_edge(clk) then
		clr_delay_regs <= not rst_n;
	end if;
end process;

en_latch <= token_dline(token_dline'length-1);
en_regs <= token_dline(token_dline'length-2);--2
VOUT <= token_dline(0);
end architecture JLookAhead;
