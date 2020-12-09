vlib work
vcom -93 -work work ../../src/globals.vhd
vcom -93 -work work ../../src/ID/HDU_pkg.vhd
vcom -93 -work work ../../src/ID/regFile.vhd
vcom -93 -work work ../../src/ID/BPU.vhd
vcom -93 -work work ../../src/ID/instDecoder.vhd
vcom -93 -work work ../../src/ID/IDStage.vhd
vcom -93 -work work ../../src/ID/instDecoder.vhd

vcom -93 -work work ../../src/IF/test/Memory.vhd
vcom -93 -work work ../../src/IF/IF_behavioral.vhd
vcom -93 -work work ../../src/riscvProcessor.vhd

vcom -93 -work work ../../tb/testbench.vhd

vsim -c -do "vsim work.testbench; run 1 us; exit"
