library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

architecture behavior of adder is
    signal temp_sum: unsigned(N downto 0);
begin
    temp_sum <= unsigned(a) + unsigned(b) + unsigned ('0' & cin);
    s <= temp_sum(N-1 downto 0);
    cout <= temp_sum(N);
end architecture behavior;
