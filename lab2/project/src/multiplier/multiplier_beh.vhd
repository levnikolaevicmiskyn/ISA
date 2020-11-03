library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity multiplier_beh is
	generic(NBIT: integer := 32);
	port(clk: in std_logic;
		A, B: in std_logic_vector(NBIT-1 downto 0);
		Z: out std_logic_vector(NBIT-1 downto 0)
	);
end entity;


architecture behavior of multiplier_beh is
constant NPIPE: integer := 2;
signal zext: unsigned(2*NBIT-1 downto 0);
signal zred: std_logic_vector(NBIT-1 downto 0);

type dline_type is array(NPIPE-1 downto 0) of std_logic_vector(NBIT-1 downto 0);
signal z_dline: dline_type;

begin
	zext <= unsigned(A)*unsigned(B);
	zred <= std_logic_vector(zext(NBIT-1 downto 0));
	
	output_proc: process(clk)
	begin
		if rising_edge(clk) then
			for i in NPIPE-1 downto 1 loop
				z_dline(i-1) <= z_dline(i);
			end loop;
			
			z_dline(NPIPE-1) <= zred;
		end if;
	end process;
	
	Z <= z_dline(0);
	
end behavior;