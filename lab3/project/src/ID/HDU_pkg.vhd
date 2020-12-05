library ieee;
use ieee.std_logic_1164.all;

package HDU_pkg is
  function hazard (rs1, rd: std_logic_vector(4 downto 0)) return std_logic;
  function hazard (rs1, rs2, rd: std_logic_vector(4 downto 0)) return std_logic;
end package HDU_pkg;

package body HDU_pkg is
  function hazard (rs1, rd: std_logic_vector(4 downto 0)) return std_logic is
    begin
      if rs1 = rd then
        return '1';
      else
        return '0';
      end if;
    end function hazard;

    function hazard (rs1, rs2, rd: std_logic_vector(4 downto 0)) return std_logic is
      begin
        if (rs1 = rd) or (rs2 = rd) then
          return '1';
        else
          return '0';
        end if;
      end function hazard;
end HDU_pkg;
