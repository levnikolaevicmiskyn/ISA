#!/bin/bash
source /software/scripts/init_questa10.7c

rm -rf work

vlib work

# Compile source
vcom -93 -work work ../src/common/*.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage1_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage2_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage3_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_stage4_struct.vhd
vcom -93 -work work ../src/multiplier/fpmul_pipeline.vhd

vlog -sv ../tb/top.sv

vsim -c -do "vsim top; run 4 us" > summary.log

