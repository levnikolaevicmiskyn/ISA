library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end entity testbench;


architecture behavior of testbench is
  component riscvProcessor is
      port(clk: in std_logic);
  end component;

  signal clk: std_logic;
begin
  proc: riscvProcessor(clk);

  procClkGen: process
              begin
                clk <= '0';
                wait for 10 ns;
                clk <= '1';
                wait for 10 ns;
              end process;
end behavior;
