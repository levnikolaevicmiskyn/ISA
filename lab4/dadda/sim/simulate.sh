#!/bin/bash
source /software/scripts/init_questa10.7c

rm -rf work

vlib work

# Compile source
vcom ../src/HA.vhd
vcom ../src/FA.vhd
vcom ../src/MBE.vhd

vlog -sv ../tb/top.sv

vsim -c -do "vsim top; run 4 us" > summary.log
