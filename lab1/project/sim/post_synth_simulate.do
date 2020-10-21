# Create working library
vlib work

# Compile VHDL files
vcom -93 -work work ../tb/simconsts.vhd
vcom -93 -work work ../tb/*.vhd

# Compile netlist
vlog -work work ../netlist/IIRFilter.v

# Compile testbench
vlog -work work ../tb/testbench.v

# Start simulation
vsim -c -do " vsim -L /software/dk/nangate45/verilog/msim6.2g work.testbench; run $1; quit"
