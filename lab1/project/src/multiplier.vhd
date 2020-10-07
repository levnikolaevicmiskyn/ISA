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
