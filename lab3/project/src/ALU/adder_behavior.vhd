library ieee;
use ieee.std_logic_1164.all;

entity adder is
    generic (N : positive);
    port (
        a: in  std_logic_vector(N-1 downto 0);
        b: in  std_logic_vector(N-1 downto 0);
        s: out std_logic_vector(N-1 downto 0)
    );
end entity adder;

architecture behavior of adder is
begin
    s <= a + b;
end architecture behavior;
