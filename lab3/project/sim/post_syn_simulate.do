vlib work

vlog ../netlist/riscvProcessor.v

vcom -93 -work work ../src/tb/Memory.vhd

vcom -93 -work work ../tb/tbController.vhd

vlog -work work ../tb/testbench.v

vsim work.testbench

run 250 us

quit -sim

exit
