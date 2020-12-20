library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Non-synthesizable two port memory
-- Port one is asynchronous and read-only. data_out_1 will be the content of
-- location pointed at by read_addr_1.
-- Port two supports read and write, the corresponding address is addr_2. Write is enabled by asserting wr_en_2.
-- If wr_en_2 is enabled, data_in_2 will be written to the location referenced
-- by addr_2 at the next clock rising edge. Otherwise, read data is available
-- on output port data_out_2. 

entity Memory is
  port(read_addr_1, addr_2    : in  std_logic_vector(31 downto 0);
       wr_en_2                : in  std_logic;
       data_in_2              : in  std_logic_vector(31 downto 0);
       data_out_1, data_out_2 : out std_logic_vector(31 downto 0)
       );
end entity Memory;

architecture behavior of Memory is
  type t_mem is array(1023 downto 0) of std_logic_vector(31 downto 0);

  signal mem : t_mem;
  begin
    procLoader : process
      file instmem    : text open read_mode is "mem.txt";
      variable fline  : line;
      variable addr   : std_logic_vector(31 downto 0);
      variable inst   : std_logic_vector(31 downto 0);
      variable addr_i : integer := 0;
    begin
      while (not endfile(instmem)) loop
        readline(instmem, fline);
        hread(fline, addr);
        hread(fline, inst);
        mem(addr_i) <= inst;
        addr_i      := addr_i + 1;
      end loop;
      file_close(instmem);
      wait;
    end process;


    data_1 <= mem(to_integer(unsigned(read_addr_1)));
    data_2 <= mem(to_integer(unsigned(read_addr_2)));

    procWrite2 : process(clk)
    begin
      if rising_edge(clk) then
        if wr_en_2 = '1' then
          mem(to_integer(unsigned(addr_2))) <= data_in_2;
          assert to_integer(unsigned(addr_2)) >= DATA_MEM_START_ADDR report "Write access to the instruction memory region!" severity warning;
        end if;
    end process;
  end behavior;
