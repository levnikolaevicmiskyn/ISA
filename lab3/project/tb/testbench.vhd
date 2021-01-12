library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end entity testbench;


architecture behavior of testbench is
component riscvProcessor is
  port(clk, rst_n                                                    : in  std_logic;
       phy_data_mem_addr, phy_instr_mem_addr, phy_data_mem_in : out std_logic_vector(31 downto 0);
       phy_instr_mem_out, phy_data_mem_out                    : in  std_logic_vector(31 downto 0);
       phy_data_mem_wr_en                                     : out std_logic);
end component;

component Memory is
    generic (
        SIZE:         positive := 1023;
        filename_in:  string;
        filename_out: string
    );
    port (
        clk:      in  std_logic;
        dump:     in  std_logic;
        address:  in  std_logic_vector(31 downto 0);
        wr_en:    in  std_logic;
        data_in:  in  std_logic_vector(31 downto 0);
        data_out: out std_logic_vector(31 downto 0)
    );
end component;

signal clk, rst_n : std_logic;
signal phy_data_mem_addr, phy_data_mem_in, phy_data_mem_out, phy_instr_mem_in, phy_instr_mem_out, phy_instr_mem_addr: std_logic_vector(31 downto 0);
signal phy_data_mem_wr_en: std_logic;
signal dump: std_logic := '0';
begin
  compProc : riscvProcessor port map(clk, rst_n, phy_data_mem_addr, phy_instr_mem_addr, phy_data_mem_in, phy_instr_mem_out, phy_data_mem_out, phy_data_mem_wr_en     );

  procClkGen : process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;
  rst_n <= '0', '1' after 1ns;

  compInstrMemory: Memory generic map(1024, "machinecode.txt", "machinecode-dump.txt")
    port map(clk, '0', phy_instr_mem_addr, '0', (others => '0'), phy_instr_mem_out);


  compDataMemory: Memory generic map(1024, "machinedata.txt", "machinedata-dump.txt")
    port map(clk, dump, phy_data_mem_addr, phy_data_mem_wr_en, phy_data_mem_in , phy_data_mem_out);
end behavior;
