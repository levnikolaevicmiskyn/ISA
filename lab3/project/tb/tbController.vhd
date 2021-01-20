library ieee;
use ieee.std_logic_1164.all;

entity tbController is
port(
	clk		: out std_logic;
	rst_n	: out std_logic;
	dump	: out std_logic
	);
end entity tbController;

architecture structure of tbController is

begin

	procClkGen : process
	  begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	  end process;
	  rst_n <= '0', '1' after 1 ns;
	  dump <= '0', '1' after 200 us, '0' after 200.03 us;

end architecture structure;
		
