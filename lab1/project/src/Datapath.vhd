library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library work;
use work.constants;
use work.fpconv.all;
use work.packets;

entity Datapath is
    port (
        CLK:    in  std_logic;              -- Clock signal
        b: 		in  std_logic_vector(constants.NBCOEFF*constants.NBINT-1 downto 0);     			-- Filter b parameters (constant)
        a:     	in  std_logic_vector(constants.NACOEFF*constants.NBINT-1 downto 0);     			-- Filter -a parameters (constant)
        DIN:    in  signed(7 downto 0);     -- Input sample
        -- Control Unit signals
        clr_w_reg: in std_logic;            -- Clear delay register
        en_latch:  in std_logic;            -- Enable latch
        -- Output
        DOUT:   out signed(7 downto 0)      -- Output sample
    );
end entity;


architecture RTL of Datapath is
    component adder is
        generic	(N_BIT: positive);
        port (
            a:         in  signed(N_BIT-1 downto 0);
            b:         in  signed(N_BIT-1 downto 0);
            carry_in:  in  std_logic;
            sum:       out signed(N_BIT-1 downto 0);
            carry_out: out std_logic
        );
    end component;

    component multiplier is
        generic (N_BIT_I: natural; N_BIT_F: natural);
        port (
            a, b:   in  signed((N_BIT_I+N_BIT_F)-1 downto 0);
            y:      out signed((N_BIT_I+N_BIT_F)-1 downto 0)
        );
    end component;

    constant NIa: natural := constants.NIa;
	constant NF: natural := constants.NF;   -- Internal data parallelism
    constant NIb: natural := constants.NIb; -- This must be the same as the interface, adopted by the last two adders
	constant NA : natural := NIa + NF;
    constant NB: natural := NIb + NF;
    signal sync_DIN, sync_DOUT: signed(7 downto 0);
    signal x: signed(NA-1 downto 0);
    signal y: signed(NB-1 downto 0);
    signal w0, w1, fb: signed(NA-1 downto 0);
    signal t_tmp, ff_tmp: signed(NA-1 downto 0); -- Feedforward multiplier output
    signal t, ff: signed(NB-1 downto 0);
    signal a1_int, b0_int, b1_int: signed(NA-1 downto 0);
	signal a1, b0, b1: signed(constants.NBINT-1 downto 0);
	
begin
	a1 <= packets.extract(a, 0, constants.NBINT);
	b0 <= packets.extract(b, 0, constants.NBINT);
	b1 <= packets.extract(b, 1, constants.NBINT);
    -- Resize coefficients to match the internal representation: the least significant bit is dropped and 
    -- sign is extendend to avoid overflow.
    a1_int <= fpresize(a1, 1, 7, NIa, NF);
    b0_int <= fpresize(b0, 1, 7, NIa, NF);
    b1_int <= fpresize(b1, 1, 7, NIa, NF);
    
    -- Sample input data on every clock rising edge
    proc_input_sample: process(clk)
    begin
        if rising_edge(clk) then
            -- Sample the input signal
            sync_DIN <= DIN;
        end if;
    end process proc_input_sample;
    -- Latch input to prevent power consuming operations when input data is not
    -- valid
    proc_input_latch: process(en_latch, clr_w_reg, sync_DIN)
    begin
		if clr_w_reg = '1' then
			x <= (others => '0');
		elsif en_latch = '1' then
			x <= fpresize(sync_DIN, 1, 7, NIa, NF);
		end if;
    end process proc_input_latch;

    -- Internal structure
    comp_sum1: adder
        generic map(NA)
        port map(x, fb, '0', w0, open);
    comp_sum2: adder
        generic map(NB)
        port map(t, ff, '0', y);
    comp_mul_a1: multiplier
        generic map(NIa, NF)
        port map(w1, a1_int, fb);
    comp_mul_b0: multiplier
        generic map(NIa, NF)
        port map(w0, b0_int, t_tmp);
    comp_mul_b1: multiplier
        generic map(NIa, NF)
        port map(w1, b1_int, ff_tmp);
    -- Discard the most significant bit from the multiplier output because
    -- the result surely fits into a smaller representation (NB bits).
    t <= fpresize(t_tmp, NIa, NF, NIb, NF);
    ff <= fpresize(ff_tmp, NIa, NF, NIb, NF);

    -- Internal register
    proc_w_reg: process(clk)
    begin
        if rising_edge(clk) then
            if clr_w_reg = '1' then
                w1 <= (others => '0');
            else
                w1 <= w0;
            end if;
        end if;
    end process proc_w_reg;
    -- Output register
    proc_out_reg: process(clk)
    begin
        if rising_edge(clk) then
            -- Pick the 8 most significant bits
            --DOUT <= y(N-1 downto N-8);
            DOUT <= fpresize(y, NIb, NF, 1, 7);
        end if;
    end process proc_out_reg;
end architecture RTL;



architecture fastRTL of Datapath is
    component adder is
        generic	(N_BIT: positive);
        port (
            a:         in  signed(N_BIT-1 downto 0);
            b:         in  signed(N_BIT-1 downto 0);
            carry_in:  in  std_logic;
            sum:       out signed(N_BIT-1 downto 0);
            carry_out: out std_logic
        );
    end component;

    component multiplier is
        generic (N_BIT_I: natural; N_BIT_F: natural);
        port (
            a, b:   in  signed((N_BIT_I+N_BIT_F)-1 downto 0);
            y:      out signed((N_BIT_I+N_BIT_F)-1 downto 0)
        );
    end component;

    constant NIa: natural := constants.NIa; -- Extended integer bits
	constant NF: natural := constants.NF; -- Accuracy is the same throughout the filter
    constant NIb: natural := constants.NIb; -- Minimum integer bits (1)
	constant NA : natural := NIa + NF; -- Total bitwidth
    constant NB: natural := NIb + NF;
	
    signal sync_DIN, sync_DOUT: signed(7 downto 0);
    signal x: signed(NA-1 downto 0);
	signal x_nb: signed(NB-1 downto 0); -- x represented with only 1 integer bit
	
    signal y: signed(NB-1 downto 0);
	-- Adder A1
	signal a1a, a1out, a1out_del: signed(NA-1 downto 0);
	-- Adder ML2
	signal m2out, m2out_del: signed(NA-1 downto 0);
	-- Adder ML1
	signal m1out: signed(NB-1 downto 0);
	-- Intermediate variables
	signal w0, w1: signed(NA-1 downto 0);
	-- Multiplier M3
	signal m3out, m4out: signed(NA-1 downto 0);
	signal m4out_del: signed(NB-1 downto 0);
	-- Adder A3
	signal a3a, a3b: signed(NB-1 downto 0);
	
	-- Coefficients
    signal a1_int, b0_int, b1_int, a1sq_int: signed(NA-1 downto 0);
	signal a1, b0, b1, a1sq: signed(constants.NBINT-1 downto 0);
	signal a1_int_b: signed(NB-1 downto 0);
	
begin
	a1 <= packets.extract(a, 0, constants.NBINT);
	b0 <= packets.extract(b, 0, constants.NBINT);
	b1 <= packets.extract(b, 1, constants.NBINT);
	a1sq <= packets.extract(a, 1, constants.NBINT);
    -- Resize coefficients to match the internal representation: the least significant bit is dropped and 
    -- sign is extendend to avoid overflow.
    a1_int <= fpresize(a1, 1, 7, NIa, NF);
	a1_int_b <= fpresize(a1, 1, 7, NIb, NF);
    b0_int <= fpresize(b0, 1, 7, NIa, NF);
    b1_int <= fpresize(b1, 1, 7, NIa, NF);
    a1sq_int <= fpresize(a1sq, 1, 7, NIa, NF);
    -- Sample input data on every clock rising edge
    proc_input_sample: process(clk)
    begin
        if rising_edge(clk) then
            -- Sample the input signal
            sync_DIN <= DIN;
        end if;
    end process proc_input_sample;
    -- Latch input to prevent power consuming operations when input data is not
    -- valid
    proc_input_latch: process(en_latch, clr_w_reg, sync_DIN)
    begin
		if clr_w_reg = '1' then
			x <= (others => '0');
		elsif en_latch = '1' then
			x <= fpresize(sync_DIN, 1, 7, NIa, NF);
		end if;
    end process proc_input_latch;
	

	x_nb <= fpresize(x, NIa, NF, NIb, NF);
	comp_a1: adder
		generic map(NA)
		port map(a1a, x, '0', a1out, open);
	
	proc_reg_m1_a1 : process(clk)
	begin
		if rising_edge(clk) then
			if clr_w_reg = '1' then
				a1a <= (OTHERS => '0');
			else
				a1a <= fpresize(m1out, NIb, NF, NIa, NF);
			end if;
		end if;
	end process;
	
	-- -a1*x(n)
	comp_m1: multiplier
		generic map(NIb, NF)
		port map(x_nb, a1_int_b, m1out);
	
	proc_reg_a1_a2 : process(clk)
	begin
		if rising_edge(clk) then
			if clr_w_reg = '1' then
				a1out_del <= (OTHERS => '0');
			else
				a1out_del <= a1out;
			end if;
		end if;
	end process;
	
	comp_a2: adder
	generic map(NA)
	port map(a1out_del, m2out_del, '0', w0, open);
	
	-- Loop multiplier
	comp_m2: multiplier
		generic map(NIa, NF)
		port map(w1, a1sq_int, m2out);
	
	proc_reg_m2_a2: process(clk)
	begin
		if rising_edge(clk) then
			if clr_w_reg='1' then
				m2out_del <= (OTHERS => '0');
			else
				m2out_del <= m2out;
			end if;
		end if;
	end process;
	
	-- This register delays w0 by one clock cycle. It also works as a pipeline register before the
	-- feedforward multipliers.
	proc_reg_w1: process(clk)
	begin
		if rising_edge(clk) then
			if clr_w_reg='1' then
				w1 <= (OTHERS => '0');
			else
				w1 <= w0;
			end if;
		end if;
	end process;
	
	comp_m3: multiplier
		generic map(NIa, NF)
		port map(w1, b0_int, m3out);
		
	comp_m4: multiplier
		generic map(NIa, NF)
		port map(w1, b1_int, m4out);
	
	-- Pipeline register at the output of M3 and M4
	proc_feedforward_pipe_reg: process(clk)
	begin
		if rising_edge(clk) then
			if clr_w_reg = '1' then
				m4out_del <= (OTHERS => '0');
			else
				m4out_del <= fpresize(m4out, NIa, NF, NIb, NF);
			end if;
		end if;
	end process;
	
	proc_feedforward_reg: process(clk)
	begin
		if rising_edge(clk) then
			if clr_w_reg = '1' then
				a3b <= (OTHERS => '0');
				a3a <= (OTHERS => '0');
			else
				a3b <= m4out_del;
				a3a <= fpresize(m3out, NIa, NF, NIb, NF);
			end if;
		end if;
	end process;
	
	comp_a3: adder
		generic map(NB)
		port map(a3a, a3b, '0', y, open);
	
    -- Output register
    proc_out_reg: process(clk)
    begin
        if rising_edge(clk) then
            -- Pick the 8 most significant bits
            DOUT <= fpresize(y, NIb, NF, 1, 7);
        end if;
    end process proc_out_reg;
end architecture fastRTL;
