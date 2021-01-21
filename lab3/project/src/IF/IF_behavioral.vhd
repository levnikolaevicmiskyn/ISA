library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.globals.all;

entity IFStage is
  port (clk, rst_n: in std_logic;
		IFSigs_load_jmp_addr, IFSigs_stall: in std_logic;
		IFSigs_jmp_addr: in std_logic_vector(31 downto 0);
        --IFSigs: in t_IFSigs;
        IDSigs: out t_IDSigs;
        address: out std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0));
end entity IFStage;

architecture behavior of IFStage is
component Memory is
  port(address: in std_logic_vector(31 downto 0);
       data: out std_logic_vector(31 downto 0));
end component;

signal pc_inc, next_pc_value: std_logic_vector(31 downto 0);
signal pc_i: std_logic_vector(31 downto 0);
  begin
	pc_inc(1 downto 0) <= pc_i(1 downto 0);
    pc_inc(31 downto 2) <= std_logic_vector(unsigned(pc_i(31 downto 2)) + to_unsigned(1, 32));
    IDSigs.next_pc <= pc_inc;
    IDSigs.pc <= pc_i;
    IDSigs.inst <= instr;
	
	-- A multiplexer selects the next address to be loaded in the pc register taking into account
	-- stall and jump conditions
	next_pc_value <= pc_i when IFSigs_stall = '1' else
						IFSigs_jmp_addr when IFSigs_load_jmp_addr = '1' else
						pc_inc;
    pc_proc: process(clk, rst_n)
    begin
      if rst_n = '0' then
        pc_i <= std_logic_vector(to_unsigned(16#00400000#, 32));
      elsif rising_edge(clk) then
		pc_i <= next_pc_value; -- Update PC register		
      end if;
    end process;

    address <= pc_i;
  end behavior;
