# Create working library
vlib work

# Compile VHDL files
vcom -93 -work work ../src/fpconv.vhd
vcom -93 -work work ../src/constants.vhd
vcom -93 -work work ../src/packets.vhd
vcom -93 -work work ../src/*.vhd
vcom -93 -work work ../tb/simconsts.vhd
vcom -93 -work work ../tb/*.vhd

# Compile testbench
vlog -work work ../tb/testbench.v

# Start simulation
vsim -c -do " vsim work.tbconf; run $1; quit"
