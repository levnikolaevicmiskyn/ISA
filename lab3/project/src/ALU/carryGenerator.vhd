library ieee;
use ieee.std_logic_1164.all;

entity carryGenerator is
    generic (N: positive := 32);
    port (
        bg: in std_logic_vector(N-1 downto 0);  -- Block generate vector
        bp: in std_logic_vector(N-1 downto 0);  -- Block propagate vector
        cin: in std_logic;                      -- Input carry
        c: out std_logic_vector(N downto 0)     -- Carry vector
    );
end entity carryGenerator;

architecture structure of carryGenerator is
begin
    c(0) <= cin;
    c(N downto 1) <= bg or (cin and bp);
end architecture structure;
