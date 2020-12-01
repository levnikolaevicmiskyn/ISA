library ieee;
use ieee.std_logic_1164.all;

entity clockGenerator is
    generic (
        RESET_DURATION: time
    );
    port (
        en: in std_logic;
        rst_n: out std_logic;
        clk: out std_logic
    );
end entity clockGenerator;

architecture behavior of clockGenerator is
    constant CLOCK_PERIOD: time := 10 ns;
    signal internal_clock: std_logic;
begin
    proc_clk: process
    begin
        if internal_clock = 'U' then
            internal_clock <= '0';
        else
            internal_clock <= not internal_clock;
        end if;
        wait for CLOCK_PERIOD / 2;
    end process proc_clk;
    clk <= internal_clock;

    proc_rst_n: process
    begin
        rst_n <= '0';
        wait for RESET_DURATION;
        rst_n <= '1';
        wait;
    end process proc_rst_n;
end architecture behavior;
