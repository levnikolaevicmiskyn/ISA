# create working library
vlib work

# compile vhdl files
vcom -93 -work work ../src/*.vhd
vcom -93 -work work *.vhd

# compile testbench
vlog -work work testbench.v

# start simulation
vsim work.testbench

# run simulation
run $time

# end simulation
quit -sim
