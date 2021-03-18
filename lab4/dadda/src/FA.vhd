library ieee;
use ieee.std_logic_1164.all;


entity FA is
port(a, b, cin: in std_logic;
	s, cout: out std_logic);
end entity FA;

architecture structure of FA is
begin
s <= a xor b xor cin;
cout <= (a and b) or (a and cin) or (b and cin);
end structure;