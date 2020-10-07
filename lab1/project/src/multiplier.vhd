library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
    generic (N_BIT: natural);
    port (
        a, b:   in  signed(N_BIT-1 downto 0);
        y:      out signed(N_BIT-1 downto 0)  	
    );
end entity multiplier;

architecture behavioral of multiplier is

	signal temp_y : signed(2*N_BIT-1 downto 0);	
												
begin

	temp_y <= a*b;
	y <= temp_y(2*N_BIT-1 downto N_BIT);

end architecture behavioral;
