-- Fractional bits and integer bits in the internal representation, respectively.
-- This will be used in the internal arithmetic components,
-- expect for those that must adopt the same bitwidth as the interface (as given by the specifications)

package constants is

	constant NF		: positive := 6;
	constant NIa	: positive := 2;	-- This is used by all multipliers and adders except for the feedforward adders
	constant NIb	: positive := 1;	 -- This is used by the feedforward adders (closer to the output)  
	
	constant NBINT 	: positive := 8;     -- Interface bitwidth for all signals
	constant NACOEFF : positive := 1;    -- Number of a coefficients
	constant NBCOEFF : positive := 2;
	
end constants;

package body constants is 
	
end constants;
