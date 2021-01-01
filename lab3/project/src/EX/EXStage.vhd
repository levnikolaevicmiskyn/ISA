library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.globals.all;


entity EXStage is
  port(clk: in std_logic;
       EXSigs: in t_EXSigs;
       EXData: out t_EXData
       -- *** FWD UNIT SIGNALS HERE ***
       );
end entity EXStage;

architecture behavior of EXStage is

begin
  EXData.result <= EXSigs.oprnd_1 when EXSigs.use_immediate = '0' else EXSigs.immediate;
  EXData.Z <= '1' when unsigned(EXSigs.oprnd_1) = to_unsigned(0, 32) else '0';
  EXData.N <= '0';
  EXData.V <= '0';
  EXData.C <= '0';
end behavior;
