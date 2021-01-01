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
  generic(filename : string);
  port(clk      : in  std_logic;
       address  : in  std_logic_vector(31 downto 0);
       wr_en    : in  std_logic;
       data_in  : in  std_logic_vector(31 downto 0);
       data_out : out std_logic_vector(31 downto 0)
       );
end entity Memory;

architecture behavior of Memory is
  type t_mem is array(1023 downto 0) of std_logic_vector(31 downto 0);

  impure function init_mem(constant filename : string) return t_mem is
    -- File handle variables
    variable open_status: FILE_OPEN_STATUS;
    file instmem     : text;
    -- Memory object
    variable mem_var : t_mem;
    -- Line from file
    variable fline   : line;
    -- Temporary variable for input data
    variable inst    : std_logic_vector(31 downto 0);
    -- Address counter, incremented at each line
    variable addr_i  : integer := 0;
  begin
    file_open(open_status,instmem, filename, READ_MODE);
    -- Check if file is open
    if open_status /= open_ok then
      report "Could not open file";
      return mem_var;
    end if;
    while (not endfile(instmem)) loop
      readline(instmem, fline);
      hread(fline, inst);
      mem_var(addr_i) := inst;
      addr_i          := addr_i + 1;
    end loop;
    file_close(instmem);
    return mem_var;
  end function;

  signal mem : t_mem := init_mem(filename);

begin
  data_out <= mem(to_integer(unsigned(address(11 downto 2))));

  assert to_integer(unsigned(address)) < 2**12 report "Address is out of range" severity warning;

  procWrite2 : process(clk)
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
        mem(to_integer(unsigned(address(11 downto 2)))) <= data_in;
      end if;
    end if;
  end process;
end behavior;
