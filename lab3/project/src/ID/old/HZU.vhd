library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HZU is
port(ID_rd: in std_logic_vector(4 downto 0);
	 rs1, rs2: in std_logic_vector(4 downto 0);
	 rs1_valid, rs2_valid: std_logic;
	 ID_mem_read: in std_logic;
	 stall: out std_logic
	 );
end entity HZU;

architecture behavior of HZU is
signal equal_rs1, equal_rs2, equal: std_logic;
begin
equal_rs1 <= '1' when rs1 = ID_rd else '0';
equal_rs2 <= '1' when rs2 = ID_rd else '0';
equal <= (equal_rs1 and rs1_valid) or (equal_rs2 and rs2_valid);
stall <= ID_mem_read and equal;
end behavior;
