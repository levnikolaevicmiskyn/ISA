library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BPU is
  generic(N : integer := 3);
  port(clk, rst_n, branch : in  std_logic;
       pc                 : in  std_logic_vector(31 downto 0);
       ID_misprediction   : in  std_logic;
       prediction         : out std_logic);
end entity BPU;

architecture behavior of BPU is
  signal branch_dline : std_logic_vector(1 downto 0);
  signal taken_dline  : std_logic_vector(1 downto 0);

  type t_pc_dline is array(1 downto 0) of unsigned(N-1 downto 0);
  signal pc_dline : t_pc_dline;

  type pht is array (2**N - 1 downto 0) of unsigned(1 downto 0);
  signal counters : pht;

  signal m_prediction, outcome : std_logic;
  signal current_value         : unsigned(1 downto 0);

begin
  comp_branch_dline : process(clk, rst_n)
  begin
    if rst_n = '0' then
      branch_dline <= (others => '0');
    elsif rising_edge(clk) then
      for i in branch_dline'length-1 downto 1 loop
        branch_dline(i-1) <= branch_dline(i);
      end loop;
      branch_dline(branch_dline'length-1) <= branch;
    end if;
  end process;

  comp_taken_dline : process(clk)
  begin
    if rising_edge(clk) then
      for i in taken_dline'length-1 downto 1 loop
        taken_dline(i-1) <= taken_dline(i);
      end loop;
      taken_dline(taken_dline'length-1) <= m_prediction;
    end if;
  end process;

  comp_pc_dline : process(clk)
  begin
    if rising_edge(clk) then
      for i in branch_dline'length-1 downto 1 loop
        pc_dline(i-1) <= pc_dline(i);
      end loop;
      -- Use the lower N bits from address
      pc_dline(pc_dline'length-1) <= unsigned(pc(N+1 downto 2));
    end if;
  end process;

  prediction <= m_prediction;
  --prediction <= '1';

  current_value <= counters(to_integer(unsigned(pc(N+1 downto 2))));
  m_prediction  <= current_value(1);  -- when counter's value is greater than 1

  outcome <= taken_dline(0) xor ID_misprediction;

  proc_update : process(clk, rst_n)
  begin
    if rst_n = '0' then
      for i in 2**N-1 downto 0 loop
        counters(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk) then
      if (branch_dline(0) = '1') and (outcome = '1') and (counters(to_integer(pc_dline(0))) /= "11") then
        -- Taken: increment counter
        counters(to_integer(pc_dline(0))) <= ((counters(to_integer(pc_dline(0)))) + to_unsigned(1, 2));
      end if;
      if (branch_dline(0) = '1') and (outcome = '0') and (counters(to_integer(pc_dline(0))) /= "00") then
        -- Not taken: decrement counter
        counters(to_integer(pc_dline(0))) <= ((counters(to_integer(pc_dline(0)))) - to_unsigned(1, 2));
      end if;
    end if;

  end process;


end behavior;
