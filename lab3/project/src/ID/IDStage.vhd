library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDStage is
port(clk: in std_logic;
	 inst: in std_logic_vector(31 downto 0);
	 pc: in std_logic_vector(31 downto 0);
	 wb_reg_write: in std_logic 
	 alu_use_immediate: out std_logic;
	 alu_op: out t_ALU_OP;
	 alu_oprnd_1, alu_oprnd_2, alu_immediate: out std_logic_vector(31 downto 0);
	 mem_write, mem_read: out std_logic
	 );
end entity IDStage;

architecture RTL of IDStage is

component instDecoder is
    port(inst: in std_logic_vector(31 downto 0);
		 op: out ALU_OP;
		 alu_use_immediate, use_pc: out std_logic;
		 mem_write, mem_read, reg_write, mem_to_reg: out std_logic;
		 immediate: out std_logic_vector(31 downto 0);
		 rs1, rs2, rd: out std_logic_vector(4 downto 0)
		);
end component;

component regFile is
port ( clk, reg_write: in std_logic;
	   read_addr_1, read_addr_2, write_addr_1: in std_logic_vector(4 downto 0);
	   write_data_1: in std_logic_vector(31 downto 0);
	   read_data_1, read_data_2: out std_logic_vector(31 downto 0) );
end component;


signal read_addr_1, read_addr_2, write_addr_1: std_logic_vector(4 downto 0);
signal write_data_1, read_data_1, read_data_2: std_logic_vector(31 downto 0);

begin
end RTL;