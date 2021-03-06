library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package fpconv is
    -- Resize a fixed point number
    function fpresize(
        X: SIGNED;      -- Input
        NIx: INTEGER;   -- Input's number of integer bits
        NFx: INTEGER;   -- Input's number of fractional bits
        NIy: INTEGER;   -- Output's number of integer bits
        NFy: INTEGER    -- Output's number of fractional bits
    ) return SIGNED;    -- Output
end fpconv;

package body fpconv is
    function fpresize(X: SIGNED; NIx: INTEGER; NFx:INTEGER; NIy: INTEGER;
        NFy: INTEGER) return SIGNED is
        variable y: SIGNED(NIy+NFy-1 downto 0);
    begin
        if NFx >= NFy then
            y(NFy-1 downto 0) := X(NFx-1 downto NFx-NFy);
        else
            y(NFy-1 downto NFy-NFx) := X(NFx-1 downto 0);
            y(NFy-Nfx-1 downto 0) := (OTHERS => '0');
        end if;

        if NIx >= NIy then
            y(y'LENGTH-1 downto y'LENGTH-NIy) := X(NFx + NIy - 1 downto NFx);
        else
            y(y'LENGTH-1 downto NFy+NIx) := (OTHERS => X(X'length-1));
            y(NFy+NIx-1 downto NFy) := X(X'length-1 downto X'length-NIx);
        end if;
        return y;
    end function fpresize;
end fpconv;
