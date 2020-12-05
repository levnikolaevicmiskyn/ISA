library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    generic (N : positive := 32);
    port (
        a: in  std_logic_vector(N-1 downto 0);
        b: in  std_logic_vector(N-1 downto 0);
        s: out std_logic_vector(N-1 downto 0)
    );
end entity adder;

architecture behavior of adder is
begin
    s <= std_logic_vector(unsigned(a) + unsigned(b));
end architecture behavior;
