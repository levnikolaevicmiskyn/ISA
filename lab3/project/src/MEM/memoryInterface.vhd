library ieee;
use ieee.std_logic_1164.all;

-- inst_address: Instruction memory location address
-- data_address: Data memory location address
-- rd: Data memory read signal
-- wr: Data memory write enable signal
-- data_out: Data memory output
-- inst_out Instruction memory output

entity memoryInterface is
  port (
        inst_address, data_address : in  std_logic_vector(31 downto 0);
        rd, wr                     : in  std_logic;
        data_in                    : in  std_logic_vector(31 downto 0);
        data_out, instr_out: out std_logic_vector(31 downto 0);
        phy_mem_data_in, phy_mem_data_addr, phy_mem_instr_addr: out std_logic_vector(31 downto 0);
        phy_mem_wr_en: out std_logic;
        phy_mem_data_out, phy_mem_instr_out: in std_logic_vector(31 downto 0));
end entity memoryInterface;


architecture behavior of memoryInterface is
  signal shifted_data_addr : std_logic_vector(31 downto 0);
  signal lower_data_address : std_logic_vector(31 downto 0);
  signal lower_instr_address: std_logic_vector(31 downto 0);
begin
  lower_data_address <= (31 downto 10 => '0') & data_address(9 downto 0);
  lower_instr_address <= (31 downto 10 => '0') & inst_address(9 downto 0);

  phy_mem_data_in <= data_in;
  phy_mem_data_addr <= lower_data_address;
  phy_mem_instr_addr <= lower_instr_address;
  phy_mem_wr_en <= wr;

  data_out <= phy_mem_data_out;
  instr_out <= phy_mem_instr_out;
  
end behavior;
