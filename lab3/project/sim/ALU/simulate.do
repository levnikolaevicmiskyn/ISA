# Create work directory
vlib work

# Compile adder
vcom -work work ../../src/ALU/GPGenerator.vhd
vcom -work work ../../src/ALU/blockGPGenerator_LadnerFischer.vhd
vcom -work work ../../src/ALU/carryGenerator.vhd
vcom -work work ../../src/ALU/sumGenerator.vhd
vcom -work work ../../src/ALU/adder_CLA.vhd

vcom -work work ../../tb/ALU/ALUFileReader.vhd
vcom -work work ../../src/ALU/tb_adder.vhd

# Strart simulation
vsim -c -do "vsim work.testbench; run 1 us; exit"
