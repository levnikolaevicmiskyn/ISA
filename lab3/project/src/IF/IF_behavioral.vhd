library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.globals.all;

entity IFStage is
  port (clk, rst_n: in std_logic;
        IFSigs: in t_IFSigs;
        IDSigs: out t_IDSigs;
        address: out std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0));
end entity IFStage;

architecture behavior of IFStage is
component Memory is
  port(address: in std_logic_vector(31 downto 0);
       data: out std_logic_vector(31 downto 0));
end component;

signal pc_inc: std_logic_vector(31 downto 0);
signal pc_i: std_logic_vector(31 downto 0);
  begin
    pc_inc <= std_logic_vector(unsigned(pc_i) + to_unsigned(4, 32));
    IDSigs.next_pc <= pc_inc;
    IDSigs.pc <= pc_i;
    IDSigs.inst <= instr;

    pc_proc: process(clk, rst_n, IFSigs.load_jmp_addr)
    begin
      if rst_n = '0' then
        pc_i <= std_logic_vector(to_unsigned(16#00400000#, 32));
      elsif rising_edge(clk) then
        if IFSigs.stall = '1' then
          pc_i <= pc_i;
        elsif IFSigs.load_jmp_addr = '1' then
          pc_i <= IFSigs.jmp_addr;
        else
        pc_i <= pc_inc;
        end if;
        end if;
    end process;
    

    address <= pc_i;
  end behavior;
