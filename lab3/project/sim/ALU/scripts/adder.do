# Create work directory
vlib work

# Compile adder
vcom -work work ../../src/ALU/arithmetic/GPCombiner.vhd
vcom -work work ../../src/ALU/arithmetic/GPGenerator.vhd
vcom -work work ../../src/ALU/arithmetic/blockGPGenerator_LadnerFischer.vhd
vcom -work work ../../src/ALU/arithmetic/carryGenerator.vhd
vcom -work work ../../src/ALU/arithmetic/sumGenerator.vhd
vcom -work work ../../src/ALU/arithmetic/adder_CLA.vhd

# Testbench files
vcom -work work ../../tb/clockGenerator.vhd
vcom -work work ../../tb/dataSink.vhd
vcom -work work ../../tb/ALUFileReader.vhd
vcom -work work ../../src/ALU/tb/tb_adder.vhd

# Strart simulation
vsim -c -do "vsim work.tb_adder; run 1 us; exit"
