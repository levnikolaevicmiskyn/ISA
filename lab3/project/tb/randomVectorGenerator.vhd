library ieee;
use ieee.std_logic_1164.all;
use ieee.real.all;

entity randomVectorGenerator is
    generic (
        N: natural;
        SEED1: integer;
        SEED2: integer);
    port (
        clk: in std_logic;
        en: in std_logic;
        vec: out std_logic_vector(N-1 downto 0)
    );
end entity randomVectorGenerator;

architecture behavior of randomVectorGenerator is
begin
    proc_randomVectorGeneration: process(clk)
        variable random_real: real;
    begin
        if rising_edge(clk) then
            if en = '1' then
                for i in 0 to N-1 loop
                    uniform(SEED1, SEED2, random_real);
                    vec(i) <= '1' when random_real > 0.5 else '0';
                end loop;
            end if;
        end if;
    end process proc_randomVectorGeneration;
end architecture behavior;
