library ieee;
use ieee.std_logic_1164.all;

entity controlUnit is
    port (
        clk:            in std_logic;       -- Clock
        rst_n:          in std_logic;       -- Synch active low reset
        VIN:            in std_logic;       -- Input sample valid
        VOUT:           out std_logic;      -- Output sample valid
        clr_delay_regs: out std_logic;      -- Clear delay registers
        en_latch:       out std_logic;      -- Enable input latch
        en_regs:        out std_logic       -- Enable registers
    );
end entity controlUnit;


architecture JLookAhead of controlUnit is
constant NPIPE: integer := 3;
signal token_dline: std_logic_vector(2+NPIPE-1 downto 0);
begin
proc_delay_line: process(clk)
    begin
        if rising_edge(clk) then
            if rst_n='0' then
                token_dline <= (OTHERS => '0');
            else
                token_dline(token_dline'length-2 downto 0) <= token_dline(token_dline'length-1 downto 1);
                token_dline(token_dline'length-1) <= VIN;
            end if;
        end if;
    end process;

proc_rst_reg: process(clk)
begin
    if rising_edge(clk) then
        clr_delay_regs <= not rst_n;
    end if;
end process;

en_latch <= token_dline(token_dline'length-1);
en_regs <= token_dline(token_dline'length-2);--2
VOUT <= token_dline(0);
end architecture JLookAhead;
