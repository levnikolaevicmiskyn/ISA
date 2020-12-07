library ieee;
use ieee.std_logic_1164.all;

entity GPCombiner is
    port (
        gij: in std_logic;      -- Generate bit [i, j]
        pij: in std_logic;      -- Propagate bit [i, j]
        gjk: in std_logic;      -- Generate bit [j, k]
        pjk: in std_logic;      -- Propagate bit [j, k]
        gik: out std_logic;     -- Generate bit [i, k]
        pik: out std_logic      -- Propagate bit [i, k]
    );
end entity GPCombiner;

architecture structure of GPCombiner is
begin
    gik <= gjk or (gij and pjk);
    pik <= pij and pjk;
end architecture structure;
