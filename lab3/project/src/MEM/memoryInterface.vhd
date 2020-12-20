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
  port(read_addr_1, addr_2    : in  std_logic_vector(31 downto 0);
       wr_en_2                : in  std_logic;
       data_in_2              : in  std_logic_vector(31 downto 0);
       data_out_1, data_out_2 : out std_logic_vector(31 downto 0)
       );
  end component;

  signal shifted_addr : std_logic_vector(31 downto 0);
begin
  shifted_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(data_address)) + DATA_MEM_START_ADDR, 32));

  compMemory : Memory port map(inst_address, shifted_addr, wr, data_in, inst_out, data_out);
end behavior;
