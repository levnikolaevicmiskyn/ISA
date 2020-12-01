library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_barrelShifter is
end entity tb_barrelShifter;

architecture behavior of tb_barrelShifter is
    component barrelShifter is
        generic (
            N: positive;
            SHA_SIZE: positive;
            RADIX: positive
        );
        port (
            x: in std_logic_vector(N-1 downto 0);
            sha: in std_logic_vector(SHA_SIZE-1 downto 0);
            y: out std_logic_vector(N-1 downto 0)
        );
    end component;

    component clockGenerator is
        generic (
            RESET_DURATION: time
        );
        port (
            en: in std_logic;
            rst_n: out std_logic;
            clk: out std_logic
        );
    end component;

    component dataGenerator is
        generic (
            N: positive;
            filename: string
        );
        port (
            clk: in std_logic;
            en: in std_logic;
            data: out std_logic_vector(N-1 downto 0)
        );
    end component;

    component dataSink is
        generic (
            N: positive;
            filename: string
        );
        port (
            clk: in std_logic;
            en: in std_logic;
            data: in std_logic_vector(N-1 downto 0)
        );
    end component;

    signal clk: std_logic;
    signal x, y: std_logic_vector(31 downto 0);
    signal sha_long: std_logic_vector(31 downto 0);
    signal sha: std_logic_vector(4 downto 0);
    signal err: std_logic := '0';
begin
    comp_barrelShifter: barrelShifter
        generic map(32, 5, 1)
        port map(x, sha, y);

    comp_clkgen: clockGenerator
        generic map(1 ns)
        port map('1', open, clk);

    comp_x_datagen: dataGenerator
        generic map(32, "samples1.txt")
        port map(clk, '1', x);

    comp_sha_datagen: dataGenerator
        generic map(32, "samples2.txt")
        port map(clk, '1', sha_long);

    comp_datasink: dataSink
        generic map(32, "shift.txt")
        port map(clk, '1', y);

    sha <= sha_long(4 downto 0);

    proc_tb: process(clk)
        variable expected_result: std_logic_vector(31 downto 0);
    begin
        if rising_edge(clk) then
            if err = '0' then
                expected_result := std_logic_vector(shift_right(
                    signed(x), to_integer(unsigned(sha))));
                if y /= expected_result then
                    err <= '1';
                end if;
            end if;
        end if;
    end process proc_tb;
end architecture behavior;
