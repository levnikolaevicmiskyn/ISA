library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrelShifter is
    generic (
        N: natural := 32;           -- Input size
        SHA_SIZE: natural := 5      -- Shift amount size (usually log2(N))
    );
    port (
        x: in std_logic_vector(N-1 downto 0);           -- Operand
        sha: in std_logic_vector(SHA_SIZE-1 downto 0);  -- Shift amount
        y: out std_logic_vector(N-1 downto 0)           -- Result
    );
end entity barrelShifter;

architecture behavior of barrelShifter is
    signal sha_int : integer;
begin
    sha_int <= to_integer(unsigned(sha));
    y <= std_logic_vector(shift_right(signed(x), sha_int));
end architecture behavior;
