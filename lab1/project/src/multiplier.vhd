library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This component is a parametrized multiplier that relies on the built-in * operator.
-- The result is given with the same representation as the inputs, which are fixed-point signed numbers
-- including N_BIT_I integer bits and N_BIT_F fractional bits.
--
-- For instance, a=1.25 is represented with N_BIT_I=2 and N_BIT_F=4 as 01.0100
--
-- Generic parameters are
-- N_BIT_I: number of integer bits
-- N_BIT_F: number of fractional bits
-- Overflow condition is checked and a warning is produced accordingly.

entity multiplier is
    generic (N_BIT_I: natural; N_BIT_F: natural);
    port (
        a, b:   in  signed((N_BIT_I+N_BIT_F)-1 downto 0);   -- Factors
        y:      out signed((N_BIT_I+N_BIT_F)-1 downto 0)    -- Product
    );
end entity multiplier;

architecture behavioral of multiplier is

    signal temp_y : signed(2*(N_BIT_I + N_BIT_F)-1 downto 0);

begin
    -- Compute the result using the built-in * operator, this gives a result
    -- represented on twice the bits of the input signals.
    temp_y <= a*b;
    -- Truncate the temporary result to represent it on the same bitwidth as the input.
    -- The full representation would require 2*N_BIT_I integer bits and 2*N_BIT_F integer bits. However, in order
    -- to comply with the input representation, N_BIT_F leftmost bits are dropped with a loss in accuracy and N_BIT_I rightmost (integer) bits
    -- are removed with the risk of generating overflow.
    y <= temp_y(2*N_BIT_F + N_BIT_I - 1 downto N_BIT_F);

    -- Overflow check: issue a warning during simulation.
    -- The following statement is ignored by logic synthesis tools
    -- In order to check this, the temporary result is compared with the representation range corresponding
    -- to N_BIT_I integer bits and 2*N_BIT_F fractional bits. Satistying this constraint means that the rightmost integer bits can be safely removed,
    -- as done above.
    --pragma synthesis_off
    assert (temp_y <= 2**(N_BIT_I+2*N_BIT_F-1)-1 and temp_y > -2**(N_BIT_I+2*N_BIT_F-1)) report "Overflow occurred at time " & time'image(now) severity warning;
    --pragma synthesis_on
end architecture behavioral;
