library ieee;
use ieee.std_logic_1164.all;
library work;
use work.globals.all;

entity MEMStage is
  port(                                 -- From control unit
    MEMSigs          : in  t_MEMSigs;
    -- Results from EX stage
    EXData           : in  t_EXData;
    -- Wrong prediction flag
    ID_misprediction : out std_logic;
    -- Memory
    address          : out std_logic_vector(31 downto 0);
    rd, wr           : out std_logic;
    data_in          : in  std_logic_vector(31 downto 0);
    data_out         : out std_logic_vector(31 downto 0);
    -- Signals for WB stage
    WB_data          : out std_logic_vector(31 downto 0)
    );
end entity MEMStage;

architecture structure of MEMStage is
  signal mispred : std_logic;
begin
  procCheckMisprediction :
  process(EXData.Z, MEMSigs.branch_taken, MEMSigs.branch)
  begin
    if MEMSigs.branch = '1' then
      if (MEMSigs.branch_taken xor EXData.Z) = '0' then
        mispred <= '0';
      else
        mispred <= '1';
      end if;
    else
      mispred <= '0';
    end if;
  end process;

  ID_misprediction <= mispred;

  WB_data <= data_in;  -- Forward data received from memory to writeback stage
  data_out <= MEMSigs.data_for_mem;
  
  -- Signals for memory
  rd      <= MEMSigs.mem_read;
  wr      <= MEMSigs.mem_write;
  address <= EXData.result;

end structure;
