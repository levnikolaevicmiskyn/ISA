library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

package daddatools is
	function getj(constant n: integer) return integer;
	function d(constant j: integer) return integer;
end daddatools;


package body daddatools is

	function d(constant j: integer) return integer is
		variable dvar: integer;
		begin
			dvar := 2;
			for i in 2 to j loop
				dvar := integer(floor(real(dvar)*3/2));
			end loop;
			return dvar;
		end function d;
		
		
		function getj(constant n: integer) return integer is
			variable j, dj: integer;
			begin
				j := 1;
				dj := 2;
				while dj < n loop
					j := j+1;
					dj := integer(floor(real(dj)*3/2));
				end loop;
				return j;
		end function getj;
end package body;