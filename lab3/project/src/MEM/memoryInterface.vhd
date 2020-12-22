library ieee;
use ieee.std_logic_1164.all;

-- inst_address: Instruction memory location address
-- data_address: Data memory location address
-- rd: Data memory read signal
-- wr: Data memory write enable signal
-- data_out: Data memory output
-- inst_out Instruction memory output

entity memoryInterface is
  port (inst_address, data_address : in  std_logic_vector(31 downto 0);
        rd, wr                     : in  std_logic;
        data_in                    : in  std_logic_vector(31 downto 0);
        data_out                   : out std_logic_vector(31 downto 0);
        inst_out                   : out std_logic_vector(31 downto 0));
end entity memoryInterface;


architecture behavior of memoryInterface is
  component Memory is
  generic(filename : string)
    port(address  : in  std_logic_vector(31 downto 0);
         wr_en    : in  std_logic;
         data_in  : in  std_logic_vector(31 downto 0);
         data_out : out std_logic_vector(31 downto 0)
         );
  end component;

  signal shifted_data_addr : std_logic_vector(31 downto 0);
  signal lower_data_address : std_logic_vector(31 downto 0);
  signal lower_instr_address: std_logic_vector(31 downto 0);
begin
  lower_data_address <= (31 downto 10 => '0' & data_address(9 downto 0));
  lower_instr_address <= (31 downto 10 => '0' & inst_address(9 downto 0));
  
  compInstructionMemory : Memory port map(lower_instr_address, '0', (others=>'0'), inst_out);
  
  compDataMemory: Memory port map(lower_data_address, wr, data_in, data_out);
end behavior;
