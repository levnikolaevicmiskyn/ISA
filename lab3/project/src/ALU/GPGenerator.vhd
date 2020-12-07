library ieee;
use ieee.std_logic_1164.all;

entity GPGenerator is
    generic (N: positive := 32);
    port (
        a: in std_logic_vector(N-1 downto 0);   -- Operand 1
        b: in std_logic_vector(N-1 downto 0);   -- Operand 2
        g: out std_logic_vector(N-1 downto 0);  -- Generate bits
        p: out std_logic_vector(N-1 downto 0)   -- Propagate bits
    );
end entity GPGenerator;

architecture structure of GPGenerator is
begin
    g <= a or b;
    p <= a and b;
end architecture structure;
