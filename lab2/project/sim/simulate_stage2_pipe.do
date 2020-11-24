vlib work

vcom -93 -work work ../tb/simconsts_stage2_pipelined.vhd
vcom -93 -work work ../tb/clk_gen.vhd
vcom -93 -work work ../tb/DataGen.vhd
vcom -93 -work work ../tb/DataSink.vhd
vcom -93 -work work ../src/common/*.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage1_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage2_struct_pipelined.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage3_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage4_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_pipeline_wregs.vhd

vlog -work work ../tb/testbench.v

vsim -c -do "vsim work.testbench; run $1; quit"
