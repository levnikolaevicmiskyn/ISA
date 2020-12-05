library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFile is
port ( clk: in std_logic;
	   read_addr_1, read_addr_2, write_addr_1: in std_logic_vector(4 downto 0);
	   write_data_1: in std_logic_vector(31 downto 0);
	   read_data_1, read_data_2: out std_logic_vector(31 downto 0) );
end entity regFile;

architecture structure of regFile is
type t_mem is array(31 downto 0) of std_logic_vector(31 downto 0);
signal memory: t_mem;

signal write_addr_1_int: integer range 0 to 31;
signal read_addr_1_int, read_addr_2_int: integer range 0 to 31;
begin

-- Convert addresses to integer
write_addr_1_int <= to_integer(unsigned(write_addr_1));
read_addr_1_int  <= to_integer(unsigned(read_addr_1));
read_addr_2_int  <= to_integer(unsigned(read_addr_2));

-- Register x0 is always zero
memory(0) <= (others => '0');


proc_rd_wr: process(clk)
		    begin
		       if rising_edge(clk) then
					-- Read
					read_data_1 <= memory(read_addr_1_int);
					read_data_2 <= memory(read_addr_2_int);
					
					-- Write
					if write_addr_1_int /= 0 then
						memory(write_addr_1_int) <= write_data_1;
					end if;
			   end if;
            end process;
end structure;