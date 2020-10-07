library ieee;
use ieee.std_logic_1164.all;

entity controlUnit is
	port(clk, rst_n, VIN: IN STD_LOGIC;
		VOUT: OUT STD_LOGIC;
		clr_delay_regs, en_latch: OUT STD_LOGIC;
		)
end entity controlUnit;

architecture behavior of controlUnit is
type state_type is (RESET_ST, IDLE, LATCH_EN_1, LATCH_EN_OUT_VAL, OUT_VAL);
SIGNAL present_state, next_state: state_type;

BEGIN

output_proc: PROCESS(present_state)
BEGIN
	-- Default signal assignments: all signals are driven with a logic zero
	-- in the default condition.
	VOUT <= '0';
	en_latch <= '0';
	clr_delay_regs <= '0';
	
	CASE present_state IS
		WHEN RESET_ST =>
			clr_delay_regs <= '1';
		WHEN IDLE => 
			-- Wait for a new sample
		WHEN LATCH_EN_1 =>
			en_latch <= '1';
		WHEN LATCH_EN_OUT_VAL =>
			en_latch <= '1';
			VOUT <= '1';
		WHEN OUT_VAL =>
			VOUT <= '1';
		WHEN OTHERS =>
			-- Default signal assignments
	END CASE;
END PROCESS;

next_state_proc: PROCESS(present_state, VIN)
BEGIN
	CASE present_state IS
		WHEN RESET_ST => 
			if VIN = '1' then
				next_state <= LATCH_EN_1;
			else
				next_state <= IDLE;
			end if;
		WHEN IDLE =>
			if VIN = '1' then
				next_state <= LATCH_EN_1;
			else
				next_state <= IDLE;
			end if;
		WHEN LATCH_EN_1 =>
			if VIN = '1' then
				next_state <= LATCH_EN_OUT_VAL;
			else
				next_state <= OUT_VAL;
			end if;
		WHEN LATCH_EN_OUT_VAL =>
			if VIN = '1' then
				next_state <= LATCH_EN_OUT_VAL;
			else
				next_state <= OUT_VAL;
			end if;
		WHEN OUT_VAL =>
			if VIN = '1' then
				next_state <= LATCH_EN_1;
			else
				next_state <= IDLE;
			end if;
		WHEN OTHERS =>
			next_state <= RESET_ST;
		END CASE;
			
END PROCESS;

state_assignment_proc: PROCESS(clk)
BEGIN
	if rising_edge(clk) then
		if rst_n = '1' then
			present_state <= next_state;
		else
			present_state <= RESET_ST;
		end if;
	end if;
	
END PROCESS;
end architecture behavior;