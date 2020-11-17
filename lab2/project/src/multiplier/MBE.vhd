library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MBE is
	port(clk, rst: in std_logic;
		m_and, m_ier: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
		);
end entity MBE;

architecture RTL of MBE is

signal x: std_logic_vector(31 downto 0);
signal xjm1: std_logic;

signal pproduct_neg: std_logic_vector(32 downto 0);
signal pproduct: std_logic_vector(34 downto 0);

-- a and 2a, extended on 33 bits (N+1)
signal a_2, a: std_logic_vector(32 downto 0);

signal s: std_logic;
signal booth_enc_window: std_logic_vector(2 downto 0);

begin

a_2(32 downto 1) <= m_and(31 downto 0);
a_2(0) <= '0':
a(31 downto 0) <= m_and;
a(32) <= a(31);

-- Shift register containing the multiplier: shifts by 2 at every clock cycle
shift_reg_m_ier : process(clk)
begin
	if rising_edge(clk) then
		if rst = '0' then
			x <= m_ier; -- Load multiplier in x register on reset
		else
			for i in 31 downto 2 loop
				x(i-2 downto i-3) <= x(i downto i-1); -- Shift by 2
			end loop;
		end if;
	end if;
end process;

s <= x(2);

-- Flip flop holding x(j-1)
ff_xjm1_proc: process(clk)
	if rising_edge(clk) then
		if rst='1' then
			xjm1 <= '0';
		else
			xjm1 <= x(0);
		end if;
	end if;
end process;

booth_enc_window(2 downto 1) <= x(1 downto 0);
booth_enc_window(0) <= xjm1;

-- Select among 2a, a or 0
BEU_comb_proc: pproduct_neg <= a_2 when (booth_enc_window = "011" or booth_encoding_window = "100") else
							a when (booth_enc_window = "011" or booth_enc_window = "010" or booth_enc_window = "101" or booth_enc_window = "110") else
							(OTHERS => '0');

-- Complement if partial product is negative
selector_proc: process(pproduct_neg)
begin
	for i in 0 to pproduct_neg'length-1 loop
		if booth_enc_window(2) then
			pproduct(i) <= not pproduct_neg(i);
		else
			pproduct(i) <= pproduct_neg(i);
		end if;
	end loop;
end process;

end RTL;