library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    generic (N : positive := 32);
    port (
        a: in  std_logic_vector(N-1 downto 0);  -- First operand
        b: in  std_logic_vector(N-1 downto 0);  -- Second operand
        sub: in std_logic;                      -- Subtract instead of adding
        s: out std_logic_vector(N-1 downto 0);  -- Sum
        cout: out std_logic                     -- Output carry
    );
end entity adder;

architecture behavior of adder is
    signal cin: std_logic;
    signal sign_mask: std_logic_vector(N-1 downto 0);
    signal signed_b: std_logic_vector(N-1 downto 0);
    signal temp_sum: unsigned(N downto 0);
begin
    sign_mask <= (others => sub);
    signed_b <= b xor sign_mask;
    cin <= sub;
    temp_sum <= unsigned(a) + unsigned(b) + unsigned ('0' & cin);
    s <= temp_sum(N-1 downto 0);
    cout <= temp_sum(N);
end architecture behavior;
