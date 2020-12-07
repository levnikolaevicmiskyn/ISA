library ieee;
use ieee.std_logic_1164.all;

entity sumGenerator is
    generic (N: positive := 32);
    port (
        a: in std_logic_vector(N-1 downto 0);   -- Operand 1
        b: in std_logic_vector(N-1 downto 0);   -- Operand 2
        c: in std_logic_vector(N-1 downto 0);   -- Carry in vector
        s: out std_logic_vector(N-1 downto 0)   -- Sum
    );
end entity sumGenerator;

architecture structure of sumGenerator is
begin
    s <= a xor b xor c;
end architecture structure;
