library ieee;
use ieee.std_logic_1164.all;

entity test is
port (clk: in std_logic;
      instr: in std_logic_vector(7 downto 0)
      s1, s2, s3, s4: out std_logic);
end entity test;

architecture behavior of test is
type ctyp is (e1, e2, e3, e4, e5, e6, e7);
signal ss: ctyp;

  begin
    proc1: process(instr)
    begin
      case instr is
         when "00000001" => ss <= e1;
         when "00000010" => ss <= e2;
         when "01001110" => ss <= e3;
         when "00011100" => ss <= e4;
      end case;
    end process;
  end behavior;
