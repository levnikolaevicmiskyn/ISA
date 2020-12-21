# Create work directory
vlib work

# Compile adder
vcom -work work ../../src/ALU/GPCombiner.vhd
vcom -work work ../../src/ALU/GPGenerator.vhd
vcom -work work ../../src/ALU/blockGPGenerator_LadnerFischer.vhd
vcom -work work ../../src/ALU/carryGenerator.vhd
vcom -work work ../../src/ALU/sumGenerator.vhd
vcom -work work ../../src/ALU/adder_CLA.vhd

# Testbench files
vcom -work work ../../tb/clockGenerator.vhd
vcom -work work ../../tb/dataSink.vhd
vcom -work work ../../tb/ALUFileReader.vhd
vcom -work work ../../src/ALU/tb_adder.vhd

# Strart simulation
vsim -c -do "vsim work.tb_adder; run 1 us; exit"
