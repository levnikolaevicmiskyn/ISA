library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFStage is
  port (clk: in std_logic;
        IF_load_jmp_addr: in std_logic;
        IF_jmp_addr: in std_logic_vector(31 downto 0);
        IF_stall, IF_load_nop: in std_logic;
        pc: out std_logic_vector(31 downto 0);
        next_pc: out std_logic_vector(31 downto 0);
        instr: out std_logic_vector(31 downto 0));
end entity IFStage;

architecture behavior of IFStage is
component Memory is
  port(address: in std_logic_vector(31 downto 0);
       data: out std_logic_vector(31 downto 0));
end component;

signal pc_inc, address, data: std_logic_vector(31 downto 0);
constant NOP: std_logic_vector(31 downto 0) := ((31 downto 7=> '0') & "0010011");
signal pc_i: std_logic_vector(31 downto 0);
  begin
    pc_inc <= std_logic_vector(unsigned(pc_i) + to_unsigned(4, 32));
    next_pc <= pc_inc;
    
    compMemInterface: Memory port map(address, data);

    address <= address when IF_stall = '1' else
               IF_jmp_addr when IF_load_jmp_addr = '1' else pc_inc;

procOut: process(clk)
         begin
           if rising_edge(clk) then
             pc_i <= address;
             if IF_load_nop = '0' then
               instr <= data;
             else
               instr <= NOP;
             end if;
           end if;
         end process;
pc <= pc_i;
  end behavior;
