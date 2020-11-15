library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package packets is
    -- Extract a single signal from a std_logic_vector containing
    -- multiple signals
    function extract(
        signal insig : std_logic_vector;    -- Input singal
        constant index: natural;            -- Index of the signal
        constant bitwidth: natural          -- Number of bits of a single signal
    ) return signed;
end packets;

package body packets is
    function extract(signal insig : std_logic_vector; constant index: natural;  constant bitwidth: natural) return signed is
        variable y: signed(bitwidth-1 downto 0);
        begin
            y := signed(insig((index+1)*bitwidth-1 downto index*bitwidth));
            return y;
    end function extract;
end package body;
