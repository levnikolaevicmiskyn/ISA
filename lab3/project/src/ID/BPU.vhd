library ieee;
use ieee.std_logic_1164.all;

entity BPU is
  port(pc: in std_logic_vector(31 downto 0);
       ID_misprediction: in std_logic;
       prediction: out std_logic);
end entity BPU;

architecture behavior of BPU is
  begin
    -- Predict taken
    prediction <= '1';
  end behavior;
