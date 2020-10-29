library ieee;
use ieee.std_logic_1164.all;

entity controlUnit is
	port(clk, rst_n, VIN: in std_logic;
		VOUT: out std_logic;
		clr_delay_regs, en_latch: out std_logic
		);
end entity controlUnit;

architecture behavior of controlUnit is
type state_type is (RESET_ST, IDLE, LATCH_EN_1, LATCH_EN_OUT_VAL, OUT_VAL);
signal present_state, next_state: state_type;

begin

output_proc: process(present_state)
begin
	-- Default signal assignments: all signals are driven with a logic zero
	-- in the default condition.
	VOUT <= '0';
	en_latch <= '0';
	clr_delay_regs <= '0';
	
	case present_state is
		when RESET_ST =>
			clr_delay_regs <= '1';
		when IDLE => 
			-- Wait for a new sample
		when LATCH_EN_1 =>
			en_latch <= '1';
		when LATCH_EN_OUT_VAL =>
			en_latch <= '1';
			VOUT <= '1';
		when OUT_VAL =>
			VOUT <= '1';
		when others =>
			-- Default signal assignments
	end case;
end process;

next_state_proc: process(present_state, VIN)
begin
	case present_state is
		when RESET_ST => 
			if VIN = '1' then
				next_state <= LATCH_EN_1;
			else
				next_state <= IDLE;
			end if;
		when IDLE =>
			if VIN = '1' then
				next_state <= LATCH_EN_1;
			else
				next_state <= IDLE;
			end if;
		when LATCH_EN_1 =>
			if VIN = '1' then
				next_state <= LATCH_EN_OUT_VAL;
			else
				next_state <= OUT_VAL;
			end if;
		when LATCH_EN_OUT_VAL =>
			if VIN = '1' then
				next_state <= LATCH_EN_OUT_VAL;
			else
				next_state <= OUT_VAL;
			end if;
		when OUT_VAL =>
			if VIN = '1' then
				next_state <= LATCH_EN_1;
			else
				next_state <= IDLE;
			end if;
		when others =>
			next_state <= RESET_ST;
		end case;
			
end process;

state_assignment_proc: process(clk)
begin
	if rising_edge(clk) then
		if rst_n = '1' then
			present_state <= next_state;
		else
			present_state <= RESET_ST;
		end if;
	end if;
end process;
end architecture behavior;


architecture fastfsm of controlUnit is
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
VOUT <= token_dline(0);
end architecture fastfsm;
