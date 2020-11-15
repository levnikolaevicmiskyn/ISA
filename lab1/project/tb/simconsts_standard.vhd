-- This package contains constants to be used by the testbench components.

package simconsts is
	constant LATENCY		: positive := 2;		-- 	Expected latency of the DUT, used to determine how many clock cycles are in between VIN and VOUT
	constant SAMPLING_FACTOR	: positive := 3;	-- 	Clock frequency/Sampling frequency. The data generator will assert VIN and fetch the next sample from the input file 
													--	once every SAMPLING_FACTOR clock cycles. If this is set to 1, VIN is always '1'
end simconsts;

package body simconsts is 
	
end simconsts;
