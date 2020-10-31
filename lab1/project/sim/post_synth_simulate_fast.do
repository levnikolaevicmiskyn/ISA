# Create working library
vlib work

# Compile VHDL files
vcom -93 -work work ../tb/simconsts_fast.vhd
vcom -93 -work work ../tb/clk_gen.vhd
vcom -93 -work work ../tb/dataGen.vhd
vcom -93 -work work ../tb/dataSink.vhd

# Compile netlist
vlog -work work ../netlist/IIRFilter.v

# Compile testbench
vlog -work work ../tb/testbench_fast.v

# Start simulation with backannotation
vsim -c -do " vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /testbench/comp_IIRFilter=../netlist/IIRFilter.sdf work.testbench; vcd file ../vcd/IIRFilter.vcd; vcd add /testbench/comp_IIRFilter/*; run $1; quit"
