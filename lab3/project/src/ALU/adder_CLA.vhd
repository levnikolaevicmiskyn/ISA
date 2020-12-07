library ieee;
use ieee.std_logic_1164.all;

entity adder is
    generic (N : positive := 32);
    port (
        a: in  std_logic_vector(N-1 downto 0);
        b: in  std_logic_vector(N-1 downto 0);
        cin: in std_logic;
        s: out std_logic_vector(N-1 downto 0);
        cout: out std_logic
    );
end entity adder;

architecture CLA of adder is
    component GPGenerator is
        generic (N: positive := 32);
        port (
            a: in std_logic_vector(N-1 downto 0);   -- Operand 1
            b: in std_logic_vector(N-1 downto 0);   -- Operand 2
            g: out std_logic_vector(N-1 downto 0);  -- Generate bits
            p: out std_logic_vector(N-1 downto 0)   -- Propagate bits
        );
    end component;

    component blockGPGenerator is
        generic(N: positive := 32);
        port (
            g: in std_logic_vector(N-1 downto 0);       -- Generate vector
            p: in std_logic_vector(N-1 downto 0);       -- Propagate vector
            bg: out std_logic_vector(N-1 downto 0);     -- Block generate vector
            bp: out std_logic_vector(N-1 downto 0)      -- Block propagate vector
        );
    end component;

    component carryGenerator is
        generic (N: positive := 32);
        port (
            bg: in std_logic_vector(N-1 downto 0);  -- Block generate vector
            bp: in std_logic_vector(N-1 downto 0);  -- Block propagate vector
            cin: in std_logic;                      -- Input carry
            c: out std_logic_vector(N downto 0)     -- Carry vector
        );
    end component;

    component sumGenerator is
        generic (N: positive := 32);
        port (
            a: in std_logic_vector(N-1 downto 0);   -- Operand 1
            b: in std_logic_vector(N-1 downto 0);   -- Operand 2
            c: in std_logic_vector(N-1 downto 0);   -- Carry in vector
            s: out std_logic_vector(N-1 downto 0)   -- Sum
        );
    end component;

    signal g: std_logic_vector(N-1 downto 0);   -- Generate bits
    signal p: std_logic_vector(N-1 downto 0);   -- Propagate bits
    signal bg: std_logic_vector(N-1 downto 0);  -- Block generate bits
    signal bp: std_logic_vector(N-1 downto 0);  -- Block propagate bits
    signal ci: std_logic_vector(N downto 0);    -- Carry vector
begin
    -- Generate the generate and propagate bits
    comp_GPGenerator: GPGenerator
        generic map(N)
        port map(a, b, g, p);
    -- Combine them in block generate and propagate
    comp_blockGPGenerator: blockGPGenerator
        generic map(N)
        port map(g, p, bg, bp);
    -- Generate actual carry vector
    comp_carryGenerator: carryGenerator
        generic map(N)
        port map(bg, bp, cin, ci);
    -- Make sum
    comp_sumGenerator: sumGenerator
        generic map(N)
        port map(a, b, ci(N-1 downto 0), s);
    cout <= ci(N);
end architecture CLA;
