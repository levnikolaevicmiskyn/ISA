library ieee; 
use ieee.std_logic_1164.all;

entity adder is
	generic	(
				N_BIT 	: positive
			);
	port(
			a			: in signed(N_BIT-1 downto 0);
			b			: in signed(N_BIT-1 downto 0);
			carry_in	: in std_logic;
			sum			: out signed(N_BIT-1 downto 0);
			carry_out	: out std_logic;
		);
end entity adder;
		
architecture behavioral of adder is

	signal temp_sum: signed(N_BIT downto 0);

begin

	temp_sum <= a + b + signed(carry_in);
	
	sum <= temp_sum(N_BIT-1 downto 0);
	
	carry_out <= temp_sum(N_BIT);

end architecture behavioral;
