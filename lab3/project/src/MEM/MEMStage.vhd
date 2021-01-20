library ieee;
use ieee.std_logic_1164.all;
library work;
use work.globals.all;

entity MEMStage is
  port(
	-- From control unit
	branch, branch_taken, mem_read, mem_write: in std_logic;
	data_for_mem: in std_logic_vector(31 downto 0);
    -- Results from EX stage
	Z: in std_logic;
	result: in std_logic_vector(31 downto 0);
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
  process(Z, branch_taken, branch)
  begin
    if branch = '1' then
      if (branch_taken xor Z) = '0' then
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
  data_out <= data_for_mem;
  
  -- Signals for memory
  rd      <= mem_read;
  wr      <= mem_write;
  address <= result;

end structure;
