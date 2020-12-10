library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;
use ieee.math_real.floor;
entity tb is
end entity tb;

architecture behavior of tb is
component MBE is
	generic(N:integer := 24);
	port(
		m_and, m_ier: in std_logic_vector(N-1 downto 0);
		z: out std_logic_vector(2*N-1 downto 0)
		);
end component;
signal x, y: std_logic_vector(23 downto 0);
signal res: std_logic_vector(47 downto 0);
signal isright: std_logic := '1';
signal clk: std_logic := '0';
begin
in_proc: process
variable seed1: integer := 1; 
variable seed2: integer := 1;
variable xreal, yreal: real;
begin
	uniform(seed1, seed2, xreal);
	uniform(seed1, seed2, yreal);
	x <= std_logic_vector(to_unsigned(integer(floor(xreal*(real(2**12)))),24));
	y <= std_logic_vector(to_unsigned(integer(floor(yreal*(real(2**12)))), 24)); 
	clk <= '1';
	wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
end process;

check_proc: process(clk)
begin
  if falling_edge(clk) then
    if unsigned(res) = unsigned(x)*unsigned(y) then
      isright <= '1';
    else
      isright <= '0';
    end if;
  end if;
end process;

assert isright = '1' report "Wrong result" severity warning;

dut: MBE generic map (24)
         port map(x, y, res);
end behavior;