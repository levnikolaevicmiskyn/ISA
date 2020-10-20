library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
    generic (N_BIT_I: natural; N_BIT_F: natural);
    port (
        a, b:   in  signed((N_BIT_I+N_BIT_F)-1 downto 0);
        y:      out signed((N_BIT_I+N_BIT_F)-1 downto 0)  	
    );
end entity multiplier;

architecture behavioral of multiplier is

	signal temp_y : signed(2*(N_BIT_I + N_BIT_F)-1 downto 0);	
												
begin

	temp_y <= a*b;
	y <= temp_y(2*N_BIT_F + N_BIT_I - 1 downto N_BIT_F);

	-- Overflow check: issue a warning during simulation.
	-- The following statement is ignored by logic synthesis tools
	assert (temp_y <= 2**(N_BIT_I+N_BIT_F-1)-1 and temp_y > -2**(N_BIT_I+N_BIT_F-1)) report "Overflow occurred at time " & time'image(now) severity warning;
end architecture behavioral;
