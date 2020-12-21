# Create work directory
vlib work

# Compile ALU
vcom -work work ../../src/ALU/GPCombiner.vhd
vcom -work work ../../src/ALU/GPGenerator.vhd
vcom -work work ../../src/ALU/blockGPGenerator_LadnerFischer.vhd
vcom -work work ../../src/ALU/carryGenerator.vhd
vcom -work work ../../src/ALU/sumGenerator.vhd
vcom -work work ../../src/ALU/adder_CLA.vhd
vcom -work work ../../src/ALU/barrelShifter_behavior.vhd
vcom -work work ../../src/ALU/ALU.vhd;

# Testbench files
vcom -work work ../../tb/clockGenerator.vhd
vcom -work work ../../tb/ALUFileReader.vhd
vcom -work work ../../tb/ALUFileWriter.vhd
vcom -work work ../../src/ALU/tb_ALU.vhd

# Strart simulation
vsim -c -do "vsim work.tb_ALU; run 700 us; exit"
