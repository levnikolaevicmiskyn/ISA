library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFStage is
  port (clk: in std_logic;
        IFSigs: in t_IFSigs;
        IDSigs: out t_IDSigs
        address: out std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0));
end entity IFStage;

architecture behavior of IFStage is
component Memory is
  port(address: in std_logic_vector(31 downto 0);
       data: out std_logic_vector(31 downto 0));
end component;

signal pc_inc, address: std_logic_vector(31 downto 0);
signal pc_i: std_logic_vector(31 downto 0);
signal instr: std_logic_vector(31 downto 0);

  begin
    pc_inc <= std_logic_vector(unsigned(pc_i) + to_unsigned(4, 32));
    IDSigs.next_pc <= pc_inc;
    IDSigs.pc <= pc;
    IDSigs.inst <= instr;

    address <= address when IFSigs.stall  = '1' else
               IFSigs.jmp_addr when IFSigs.load_jmp_addr = '1' else pc_inc;
  end behavior;
