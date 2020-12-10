vlib work

vcom -93 -work work FA.vhd
vcom -93 -work work HA.vhd
vcom -93 -work work ../../../auxilliary/dadda/MBE_24bit.vhd
vcom -93 -work work tb.vhd

vsim work.tb

run 100 us