# Create work directory
vlib work

# Compile ALU
vcom -work work ../../src/globals.vhd;
vcom -work work ../../src/ALU/ALUpkg.vhd;
vcom -work work ../../src/ALU/arithmetic/GPCombiner.vhd
vcom -work work ../../src/ALU/arithmetic/GPGenerator.vhd
vcom -work work ../../src/ALU/arithmetic/blockGPGenerator_LadnerFischer.vhd
vcom -work work ../../src/ALU/arithmetic/carryGenerator.vhd
vcom -work work ../../src/ALU/arithmetic/sumGenerator.vhd
vcom -work work ../../src/ALU/arithmetic/adder_CLA.vhd
vcom -work work ../../src/ALU/arithmetic/barrelShifter_behavior.vhd
vcom -work work ../../src/ALU/ALUController.vhd;
vcom -work work ../../src/ALU/ALUDatapath.vhd;
vcom -work work ../../src/ALU/ALU.vhd;

# Testbench files
vcom -work work ../../tb/clockGenerator.vhd
vcom -work work ../../tb/ALUFileReader.vhd
vcom -work work ../../tb/ALUFileWriter.vhd
vcom -work work ../../src/ALU/tb/tb_ALU.vhd

# Strart simulation
vsim -c -do "vsim work.tb_ALU; run 700 us; exit"
