library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package packets is
--	type sigarray is array (natural range <>) of signed(constants.NBINT-1 downto 0);
	
--	function pack(constant nrows: natural; constant bitwidth: natural; signal in_array: sigarray) return std_logic_vector;
	function extract(signal insig : std_logic_vector; constant index: natural; constant bitwidth: natural) return signed;
end packets;

package body packets is
--	function pack(signal y: out std_logic_vector; constant nrows: natural; constant bitwidth: natural; signal in_array: sigarray) return sigarray is
--		variable y: std_logic_vector(nrows*bitwidth-1 downto 0);
--		begin
--			for i in 0 to in_array'length-2 loop
--				y((i+1)*bitwidth-1 downto i*bitwidth) := std_logic_vector(in_array(i));
--			end loop;
--			
--			return y;
--	end function pack;
	
	function extract(signal insig : std_logic_vector; constant index: natural;  constant bitwidth: natural) return signed is
		variable y: signed(bitwidth-1 downto 0);
		begin
			y := signed(insig((index+1)*bitwidth-1 downto index*bitwidth));
			return y;
	end function extract;
end package body;
