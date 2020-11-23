library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MBE is
	generic(N:integer := 4);
	port(
		m_and, m_ier: in std_logic_vector(N-1 downto 0);
		z: out std_logic_vector(2*N-1 downto 0)
		);
end entity MBE;

architecture RTL of MBE is

component FA is
port(a, b, cin: in std_logic;
	s, cout: out std_logic);
end component;

component HA is
port(a, b: in std_logic;
	s, cout: out std_logic);
end component;
type matype is array(N/2 downto 0) of std_logic_vector(N downto 0); -- N/2 operands
signal pprod: matype;
signal a, a2, a_neg, a2_neg: std_logic_vector(N downto 0);
signal S: std_logic_vector(N/2 downto 0);
signal res_a, res_b: std_logic_vector(2*N-1 downto 0); 
 
-- BEGIN AUTOGEN DECL
-- END AUTOGEN DECL

begin
-- Extend multiplicand
a <= '0' & m_and;
a_neg_proc: process (a)
			begin
				for i in a'range loop
					a_neg(i) <= not a(i);
				end loop;
			end process;
			
a2_neg_proc: process (a2)
			begin
				for i in a2'range loop
					a2_neg(i) <= not a2(i);
				end loop;
			end process;
			
-- a2 = multiplicand * 2
a2 <= m_and & '0';

benc_proc: process(a, a2, a_neg, a2_neg, m_and, m_ier)
variable window: std_logic_vector(2 downto 0);
begin
	for i in 0 to N/2 loop
		if i = 0 then
			window := m_ier(1 downto 0) & '0';
		elsif i = N/2 then
			window := "00" & m_ier(N-1);
		else
			window := m_ier(2*i+1 downto 2*i-1);
		end if;
		
		if window = "000" then
			pprod(i) <= (OTHERS => '0');
		elsif window = "001" or window = "010" then
			pprod(i) <= a;
		elsif window = "101" or window = "110" then
			pprod(i) <= a_neg;
		elsif window = "011" then
			pprod(i) <= a2;
		elsif window = "100" then
			pprod(i) <= a2_neg;
		elsif window = "111" then
			pprod(i) <= (OTHERS => '1');
		end if;
		
	S(i) <= window(2);
	end loop;
end process;

-- BEGIN AUTOGEN COMPS
st1col1(0)<=st2col1(0);
st1col1(1)<=st2col1(1);
st1col2(0)<=st2col2(0);
ha1st2col3: HA port map(st2col3(0),st2col3(1),st1col3(0),st1col4(0));
st1col3(1)<=st2col3(2);
ha1st2col4: HA port map(st2col4(0),st2col4(1),st1col4(1),st1col5(0));
fa0st2col5: FA port map(st2col5(0),st2col5(1),st2col5(2),st1col5(1),st1col6(0));
fa0st2col6: FA port map(st2col6(0),st2col6(1),st2col6(2),st1col6(1),st1col7(0));
fa0st2col7: FA port map(st2col7(0),st2col7(1),st2col7(2),st1col7(1),st1col8(0));
fa0st2col8: FA port map(st2col8(0),st2col8(1),st2col8(2),st1col8(1),open);
st2col1(0) <= pprod(0) (0);
st2col2(0) <= pprod(0) (1);
st2col3(0) <= pprod(0) (2);
st2col4(0) <= pprod(0) (3);
st2col5(0) <= pprod(0) (4);
st2col1(1) <= S(0);
st2col6(0) <= S(0);
st2col7(0) <= S(0);
st2col8(0) <= not S(0);
st2col3(1) <= pprod(1) (0);
st2col4(1) <= pprod(1) (1);
st2col5(1) <= pprod(1) (2);
st2col6(1) <= pprod(1) (3);
st2col7(1) <= pprod(1) (4);
st2col3(2) <= S(1);
st2col8(1) <= not S(1);
st2col5(2) <= pprod(2) (0);
st2col6(2) <= pprod(2) (1);
st2col7(2) <= pprod(2) (2);
st2col8(2) <= pprod(2) (3);
res_a <= st1col8(0) & st1col7(0) & st1col6(0) & st1col5(0) & st1col4(0) & st1col3(0) & st1col2(0) & st1col1(0);
res_b <= st1col8(1) & st1col7(1) & st1col6(1) & st1col5(1) & st1col4(1) & st1col3(1) & '0' & st1col1(1);

-- END AUTOGEN COMPS

z <= std_logic_vector(unsigned(res_a) + unsigned(res_b));
end RTL;