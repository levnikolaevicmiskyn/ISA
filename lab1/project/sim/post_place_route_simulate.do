# Create working library
vlib work

# Compile VHDL files
vcom -93 -work work ../tb/simconsts.vhd
vcom -93 -work work ../tb/*.vhd

# Compile netlist
vlog -work work ../innovus/IIRFilter.v

# Compile testbench
vlog -work work ../tb/testbench.v

# Start simulation with backannotation
vsim -c -do " vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /testbench/comp_IIRFilter=../innovus/IIRFilter.sdf work.testbench; vcd file ../vcd/design.vcd; vcd add /testbench/comp_IIRFilter/*; run $1; quit"
