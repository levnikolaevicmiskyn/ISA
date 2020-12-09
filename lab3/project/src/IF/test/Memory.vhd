library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Memory is
  port(address: in std_logic_vector(31 downto 0);
       data: out std_logic_vector(31 downto 0));
end entity Memory;

architecture behavior of Memory is
  type t_mem is array(1023 downto 0) of std_logic_vector(31 downto 0);
  signal mem: t_mem;
  begin
    procLoader: process
      file instmem: text open read_mode is "mem.txt";
      variable fline: line;
      variable addr: std_logic_vector(31 downto 0);
      variable inst: std_logic_vector(31 downto 0);
      variable addr_i: integer := 0;
    begin
      while (not endfile(instmem)) loop
        readline(instmem, fline);
        hread(fline, addr);
        hread(fline, inst);
        mem(addr_i) <= inst;
        addr_i := addr_i + 1;
      end loop;
      file_close(instmem);
      wait;
    end process;

    data <= mem(to_integer(unsigned(address)));
  end behavior;
