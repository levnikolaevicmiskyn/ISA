library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Datapath is
    port (
        CLK:    in  std_logic;              -- Clock signal
        b1, b0: in  signed(7 downto 0);     -- Filter b parameters (constant)
        a1:     in  signed(7 downto 0);     -- Filter -a parameters (constant)
        DIN:    in  signed(7 downto 0);     -- Input sample
        -- Control Unit signals
        clr_w_reg: in std_logic;            -- Clear delay register
        en_latch: in std_logic;             -- Enable latch
        -- Output
        DOUT:   out signed(7 downto 0)     -- Output sample
    );
end entity;


architecture RTL of Datapath is
    component adder is
        generic	(N_BIT 	: positive);
        port (
            a			: in signed(N_BIT-1 downto 0);
            b			: in signed(N_BIT-1 downto 0);
            carry_in	: in std_logic;
            sum			: out signed(N_BIT-1 downto 0);
            carry_out	: out std_logic
        );
    end component;

    component multiplier is
        generic (N_BIT: natural);
        port (
            a, b:   in  signed(N_BIT-1 downto 0);
            y:      out signed(N_BIT-1 downto 0)
        );
    end component;

    constant N: natural := 8;   -- Internal data parallelism
    signal sync_DIN, sync_DOUT: signed(N-1 downto 0);
    signal x, y: signed(N-1 downto 0);
    signal w0, w1, t, fb, ff: signed(N-1 downto 0);
begin
    -- Sample input data on every clock rising edge
    proc_input_sample: process(clk)
    begin
        if rising_edge(clk) then
            -- Extend input sign in assignment
            sync_DIN <= (7 downto 0 => DIN, others => DIN(7));
        end if;
    end process proc_input_sample;
    -- Latch input to prevent power consuming operations when input data is not
    -- valid
    proc_input_latch: process(en_latch)
    begin
        if en_latch = '1' then
            x <= sync_DIN;
        end if;
    end process proc_input_latch;

    -- Internal structure
    comp_sum1: adder
        generic map(N)
        port map(x, fb, '0', w0, open);
    comp_sum2: adder
        generic map(N)
        port map(t, ff, '0', y);
    comp_mul_a1: multiplier
        generic map(N)
        port map(w1, a1, fb);
    comp_mul_b0: multiplier
        generic map(N)
        port map(w0, b0, t);
    comp_mul_b1: multiplier
        generic map(N)
        port map(w1, b1, ff);
    -- Internal register
    proc_w_reg: process(clk)
    begin
        if rising_edge(clk) then
            if clr_w_reg = '1' then
                w1 <= (others => 0);
            else
                w1 <= w0;
            end if;
        end if;
    end process proc_w_reg;
    -- Output register
    proc_out_reg: process(clk)
    begin
        if rising_edge(clk) then
            DOUT <= y(N_BIT-1 downto N_BIT-8);
        end if;
    end process proc_out_reg;
end architecture RTL;
