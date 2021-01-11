library ieee;
use ieee.std_logic_1164.all;

use work.ALUpkg.all;

entity comparatorExtension is
    generic (NB: positive := 32);
    port (
        -- ALU flags
        N, Z, C, V: in std_logic;
        -- Control signals
        signed_data: in std_logic;
        comparison: in t_Comparison;
        -- Result
        result: out std_logic_vector(NB-1 downto 0)
    );
end entity comparatorExtension;

architecture structure of comparatorExtension is
    signal overflow: std_logic;
    signal res_lt: std_logic;
    signal res_le: std_logic;
    signal res_eq: std_logic;
    signal res_ge: std_logic;
    signal res_gt: std_logic;
    signal res_lsb: std_logic;
begin
    with signed_data select overflow <=
        C when '0',
        V when others;

    res_lt <= N xor overflow;
    res_le <= res_lt or Z;
    res_eq <= Z;
    res_ge <= not res_lt;
    res_gt <= not res_le;

    with comparison select res_lsb <=
        res_lt when COMP_LT,
        res_le when COMP_LE,
        res_eq when COMP_EQ,
        res_ge when COMP_GE,
        res_gt when COMP_GT,
        'X' when others;

    result <= (31 downto 1 => '0') & res_lsb;
end architecture structure;
