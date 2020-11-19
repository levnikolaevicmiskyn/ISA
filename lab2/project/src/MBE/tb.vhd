library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end entity tb;

architecture behavior of tb is
component MBE is
	generic(N:integer := 32);
	port(
		m_and, m_ier: in std_logic_vector(N-1 downto 0);
		z: out std_logic_vector(2*N-1 downto 0)
		);
end component;
signal x, y: std_logic_vector(31 downto 0);
signal res: std_logic_vector(63 downto 0);
signal yv: integer := 1;
signal xv: integer := 2;
signal right: std_logic;
begin
in_proc: process
begin
	x <= std_logic_vector(to_unsigned(xv,32)) after 1 ns;
	y <= std_logic_vector(to_unsigned(yv , 32)) after 1 ns;
	yv <= yv+1;
	xv <= yv*3+2;
	wait for 5 ns;
end process;

check_proc: process(res)
begin
  if unsigned(res) = unsigned(x)*unsigned(y) then
    right <= '1' after 1  ns;
  else
    right <= '0' after 1 ns;
  end if;
end process;

dut: MBE generic map (32)
         port map(x, y, res);
end behavior;