library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
    generic (
        N_BIT     : natural                            -- Adder parallelism
    );
    port (
        a            : in signed(N_BIT-1 downto 0);        -- First operand
        b            : in signed(N_BIT-1 downto 0);        -- Second operand
        carry_in     : in std_logic;                       -- Input carry
        sum          : out signed(N_BIT-1 downto 0);       -- Output sum
        carry_out    : out std_logic                       -- Output carry
    );
end entity adder;

architecture behavioral of adder is
    signal temp_sum: signed(N_BIT downto 0);
    signal temp_carry_in: std_logic_vector(1 downto 0);
begin
    temp_carry_in <= '0' & carry_in;
    temp_sum <= (a(N_BIT-1) & a) + (b(N_BIT-1) & b) + signed(temp_carry_in);
    sum <= temp_sum(N_BIT-1 downto 0);
    carry_out <= temp_sum(N_BIT);
end architecture behavioral;
