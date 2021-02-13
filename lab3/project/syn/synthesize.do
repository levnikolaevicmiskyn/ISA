set VERSION 1

remove_design -designs

# Analyze source code
analyze -f vhdl -lib WORK ../src/globals_$VERSION.vhd
analyze -f vhdl -lib WORK ../src/IF/IF_behavioral.vhd

analyze -f vhdl -lib WORK ../src/ID/HDU_pkg.vhd
analyze -f vhdl -lib WORK ../src/ID/BPU.vhd
analyze -f vhdl -lib WORK ../src/ID/regFile.vhd
analyze -f vhdl -lib WORK ../src/ID/instDecoder.vhd
analyze -f vhdl -lib WORK ../src/ID/IDStage.vhd

analyze -f vhdl -lib WORK ../src/ALU/ALUpkg_$VERSION.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/comparatorExtension.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/GPCombiner.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/GPGenerator.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/sumGenerator.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/carryGenerator.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/blockGPGenerator_LadnerFischer.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/barrelShifter_behavior.vhd
analyze -f vhdl -lib WORK ../src/ALU/arithmetic/adder_CLA.vhd

analyze -f vhdl -lib WORK ../src/ALU/ALUDatapath.vhd
analyze -f vhdl -lib WORK ../src/ALU/ALUController.vhd
analyze -f vhdl -lib WORK ../src/ALU/ALU.vhd

analyze -f vhdl -lib WORK ../src/EX/EXController.vhd
analyze -f vhdl -lib WORK ../src/EX/fwdUnit.vhd
analyze -f vhdl -lib WORK ../src/EX/EXStage.vhd

analyze -f vhdl -lib WORK ../src/MEM/memoryInterface.vhd
analyze -f vhdl -lib WORK ../src/MEM/MEMStage.vhd

analyze -f vhdl -lib WORK ../src/riscvProcessor.vhd

# Elaborate

set power_preserve_rtl_hier_names true
elaborate riscvProcessor -arch structure -lib WORK

# Create clock
create_clock -name clk -period 0 {clk}
set_dont_touch_network clk

# Set uncertainties
set_clock_uncertainty 0.07 [get_clocks clk]
set_input_delay 0.5 -max -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
set_clock_uncertainty 0.07

# Check design before flattening
check_design > reports/design/check_design_$VERSION.txt

# Flatten the hierarchy
ungroup -all -flatten

# Compile
set_optimize_registers
compile_ultra -retime
#optimize_registers -clock clk


report_resources > reports/resources/report_resources_$VERSION.txt
report_area > reports/area/report_area_$VERSION.txt
report_timing > reports/timing/report_timing_$VERSION.txt

# Netlist and constraint file export
#change_names -hierarchy -rules verilog
# sdf file containing the delay of the netlist
#write_sdf ../netlist/riscvProcessor.sdf
# Save the netlist in Verilog
#write -f verilog -hierarchy -output ../netlist/riscvProcessor.v
# sdc file containts constraints to the input and output ports in a standard format
#write_sdc ../netlist/riscvProcessor.sdc
