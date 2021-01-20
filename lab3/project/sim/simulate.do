vlib work

vcom -93 -work work ../src/globals.vhd
vcom -93 -work work ../src/IF/IF_behavioral.vhd

vcom -93 -work work ../src/ID/HDU_pkg.vhd
vcom -93 -work work ../src/ID/BPU.vhd
vcom -93 -work work ../src/ID/regFile.vhd
vcom -93 -work work ../src/ID/instDecoder.vhd
vcom -93 -work work ../src/ID/IDStage.vhd

vcom -93 -work work ../src/ALU/ALUpkg.vhd
vcom -93 -work work ../src/ALU/arithmetic/comparatorExtension.vhd
vcom -93 -work work ../src/ALU/arithmetic/GPCombiner.vhd
vcom -93 -work work ../src/ALU/arithmetic/GPGenerator.vhd
vcom -93 -work work ../src/ALU/arithmetic/sumGenerator.vhd
vcom -93 -work work ../src/ALU/arithmetic/carryGenerator.vhd
vcom -93 -work work ../src/ALU/arithmetic/blockGPGenerator_LadnerFischer.vhd
vcom -93 -work work ../src/ALU/arithmetic/barrelShifter_behavior.vhd
vcom -93 -work work ../src/ALU/arithmetic/adder_CLA.vhd

vcom -93 -work work ../src/ALU/ALUDatapath.vhd
vcom -93 -work work ../src/ALU/ALUController.vhd
vcom -93 -work work ../src/ALU/ALU.vhd

vcom -93 -work work ../src/EX/EXController.vhd
vcom -93 -work work ../src/EX/fwdUnit.vhd
vcom -93 -work work ../src/EX/EXStage.vhd

vcom -93 -work work ../src/MEM/memoryInterface.vhd
vcom -93 -work work ../src/MEM/MEMStage.vhd

vcom -93 -work work ../src/riscvProcessor.vhd

vcom -93 -work work ../src/tb/Memory.vhd

vcom -93 -work work ../tb/tbController.vhd

vlog -work work ../tb/testbench.v

vsim work.testbench

run 250 us

quit -sim

exit
