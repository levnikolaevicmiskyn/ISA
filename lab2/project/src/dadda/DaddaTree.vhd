library ieee;
library work;

use ieee.std_logic_1164.all;
use work.daddatools;


entity DaddaTree is
	generic(N : integer => 8);
	port (
			a: std_logic_vector(((N+1)*(N-1) + N) - 1 downto 0);
			y1, y2: std_logic_vector(2*N-3 downto 0)
	);
end entity DaddaTree;


architecture structure of DaddaTree is
type matype is array(j downto 2, 2*N-2 downto 0) of integer;

signal a, b, c, n: matype;

type stagetype is array(N-1 downto 0, 2*N-1 downto 0) of std_logic; -- Contains all signals in a stage
type arrtype is array(j downto 2) of stagetype; --  Contains all stages

signal ops: arrtype;

begin
	gen_1: for i_st in j downto 2 generate
		gen_2: for i_col in 1 to 2*N-2 generate -- Handle boundaries separately
			
			constant offset : integer := a(i_st, i_col-1) + b(i_st, i_col-1);
			constant cur_offset_ha: integer := offset + a(i_st, i_col);
			constant next_offset_ha: integer := a(i_st, i_col);
			constant c_off: integer:= cur_offset_ha + b(i_st, i_col);
			
			begin
			-- Generate full adders
			gen_fas: for i_fa in a(i_st, i_col)-1 downto 0 generate
				full_adder: FA (ops(i_st) (3*i_fa ,i_col), ops(i_st) (3*i_fa+1, i_col), ops(i_st) (3*i_fa+2, i_col), ops(i_st-1) (offset+i_fa, i_col), ops(i_st-1) (i_fa, i_col+1))
			end generate gen_fas;
			
			-- Generate half adders
			gen_has: if b(i_st, i_col) = 1 generate
						half_adder: HA (ops(i_st) (3*a(i_st, i_col), i_col), ops(i_st) (3*a(i_st, i_col)+1, i_col), ops(i_st-1) (cur_offset_ha, i_col), ops(i_st-1) (next_offset_ha, i_col+1));
			end generate gen_has;
			
			-- Connect all remaining signals
			gen_sign: for i_sign in c(i_st, i_col)-1 downto 0 generate
					conn: ops(i_st-1) (c_off + i_sign, i_col) <= ops(i_st) (3*a(i_st, i_col) + 2*b(i_st, i_col) + i_sign, i_col);
			end generate gen_sign;
		end generate gen_2;
		-- Connect the first and last dots
		ops(i_st-1) (1 downto 0, 0) <= ops(i_st) (1 downto 0, 0);
		ops(i_st-1) () -- TODO
	end generate gen_2;
end structure;