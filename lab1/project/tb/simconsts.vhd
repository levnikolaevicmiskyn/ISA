-- This package contains constants to be used by the testbench components.
-- LATENCY: Expected latency of the DUT, used to determine how many clock cycles are in between VIN and VOUT
-- SAMPLING_FACTOR: Clock frequency/Sampling frequency. The data generator will assert VIN and fetch the next sample from the input file 
-- 					once every SAMPLING_FACTOR clock cycles. If this is set to 1, VIN is always '1'

package simconsts is
	constant LATENCY			: positive := 1;
	constant SAMPLING_FACTOR	: positive := 1;
end simconsts;

package body simconsts is 
	
end simconsts;
