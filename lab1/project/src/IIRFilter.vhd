library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants;
use work.packets;

entity IIRFilter is
    port (
        CLK:    in  std_logic;              -- Clock signal
        RST_n:  in  std_logic;              -- Synchronous reset
        b: 		in  std_logic_vector(constants.NBCOEFF*constants.NBINT-1 downto 0);     			-- Filter b parameters (constant)
        a:     	in  std_logic_vector(constants.NACOEFF*constants.NBINT-1 downto 0);     			-- Filter a parameters (constant)
        VIN:    in  std_logic;              -- Input valid
        DIN:    in  signed(7 downto 0);     -- Input sample
        DOUT:   out signed(7 downto 0);     -- Output sample
        VOUT:   out std_logic               -- Output valid
    );
end entity;

architecture RTL of IIRFilter is
    component Datapath is
        port (
            CLK:    in  std_logic;              -- Clock signal
            b: 		in  std_logic_vector(constants.NBCOEFF*constants.NBINT-1 downto 0);     -- Filter b parameters (constant)
            a:    	in  std_logic_vector(constants.NACOEFF*constants.NBINT-1 downto 0);     -- Filter -a parameters (constant)
            DIN:    in  signed(7 downto 0);     -- Input sample
            -- Control Unit signals
            clr_w_reg: in std_logic;            -- Clear delay register
            en_latch: in std_logic;             -- Enable latch
            -- Output
            DOUT:   out signed(7 downto 0)     -- Output sample
        );
    end component;

    component controlUnit is
    	port (
            clk, rst_n, VIN: IN STD_LOGIC;
    		VOUT: OUT STD_LOGIC;
    		clr_delay_regs, en_latch: OUT STD_LOGIC
    	);
    end component;
    
    signal clr_w_reg, en_latch: std_logic;
	
begin
	
    -- Instantiate control unit and dapath
    comp_cu: controlUnit
        port map(clk, rst_n, VIN, VOUT, clr_w_reg, en_latch);
    comp_dp: Datapath
        port map(clk, b, a, DIN, clr_w_reg, en_latch, DOUT);
end RTL;
