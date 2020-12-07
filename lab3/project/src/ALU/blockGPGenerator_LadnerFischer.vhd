library ieee;
use ieee.std_logic_1164.all;

entity blockGPGenerator is
    generic(N: positive := 32);
    port (
        g: in std_logic_vector(N-1 downto 0);       -- Generate vector
        p: in std_logic_vector(N-1 downto 0);       -- Propagate vector
        bg: out std_logic_vector(N-1 downto 0);     -- Block generate vector
        bp: out std_logic_vector(N-1 downto 0)      -- Block propagate vector
    );
end entity blockGPGenerator;

architecture LadnerFischer of blockGPGenerator is
    component GPCombiner is
        port (
            gij: in std_logic;      -- Generate bit [i, j]
            pij: in std_logic;      -- Propagate bit [i, j]
            gjk: in std_logic;      -- Generate bit [j, k]
            pjk: in std_logic;      -- Propagate bit [j, k]
            gik: out std_logic;     -- Generate bit [i, k]
            pik: out std_logic      -- Propagate bit [i, k]
        );
    end component;

    signal internal_bg: std_logic_vector(N-1 downto 0);
    signal internal_bp: std_logic_vector(N-1 downto 0);
begin
    gen_base_net: if N = 1 generate
        bg(0) <= g(0);
        bg(0) <= p(0);
    end generate gen_base_net;

    gen_recursive_net: if N > 1 generate
        comp_recursiveLowerHalf: blockGPGenerator
            generic map (N/2)
            port map (
                g => g(N/2 - 1 downto 0),
                p => p(N/2 - 1 downto 0),
                bg => internal_bg(N/2 - 1 downto 0),
                bp => internal_bp(N/2 - 1 downto 0)
            );
        comp_recursiveUpperHalf: blockGPGenerator
            generic map (N/2)
            port map (
                g => g(N-1 downto N/2),
                p => p(N-1 downto N/2),
                bg => internal_bg(N-1 downto N/2),
                bp => internal_bp(N-1 downto N/2)
            );
        -- Lower half goes through
        bg(N/2 - 1 downto 0) <= internal_bg(N/2 - 1 downto 0);
        bp(N/2 - 1 downto 0) <= internal_bp(N/2 - 1 downto 0);
        -- Upper half is combined with the highest lower half
        gen_combine_upperHalf: for i in N/2 to N-1 generate
            comp_upperHalfCombiner_i: GPCombiner
            port map (
                internal_bg(N/2 - 1), internal_bp(N/2 - 1),
                g(i), p(i),
                bg(i), bp(i)
            );
        end generate gen_combine_upperHalf;
    end generate gen_recursive_net;
end architecture LadnerFischer;
