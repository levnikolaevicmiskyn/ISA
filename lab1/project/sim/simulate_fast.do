# Create working library
vlib work

# Compile VHDL files
vcom -93 -work work ../src/fpconv.vhd
vcom -93 -work work ../src/constants_fast.vhd
vcom -93 -work work ../src/packets.vhd
vcom -93 -work work ../src/adder.vhd
vcom -93 -work work ../src/multiplier.vhd
vcom -93 -work work ../src/Datapath_fast.vhd
vcom -93 -work work ../src/controlUnit_fast.vhd
vcom -93 -work work ../src/IIRFilter.vhd
vcom -93 -work work ../tb/simconsts_fast.vhd
vcom -93 -work work ../tb/clk_gen.vhd
vcom -93 -work work ../tb/dataGen.vhd
vcom -93 -work work ../tb/dataSink.vhd

# Compile testbench
vlog -work work ../tb/testbench_fast.v

# Start simulation
vsim -c -do " vsim work.testbench; run $1; quit"
