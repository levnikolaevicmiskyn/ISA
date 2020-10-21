# Clear design
remove_design -designs

# Analyze components
analyze -f vhdl -lib WORK ../src/fpconv.vhd
analyze -f vhdl -lib WORK ../src/constants.vhd
analyze -f vhdl -lib WORK ../src/multiplier.vhd
analyze -f vhdl -lib WORK ../src/adder.vhd
analyze -f vhdl -lib WORK ../src/controlUnit.vhd
analyze -f vhdl -lib WORK ../src/Datapath.vhd
analyze -f vhdl -lib WORK ../src/IIRFilter.vhd


### Max Frequency Analysis ###

# Elaborate
set power_preserve_rtl_hier_names true
elaborate IIRFilter -arch RTL -lib WORK

# Setup clock
create_clock -name CLK -period 2.35 {CLK}
set_dont_touch_network CLK

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Compile
compile -gate_clock

# Save reports
report_timing > timing_max_frequency.txt
report_area > area_max_frequency.txt


### Synthesis At Lower Frequency ###

# Clear design
remove_design -designs

# Elaborate
set power_preserve_rtl_hier_names true
elaborate IIRFilter -arch RTL -lib WORK

# Setup clock
create_clock -name CLK -period 9.4 {CLK}
set_dont_touch_network CLK

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Compile
compile -gate_clock

# Save reports
report_timing > timing_low_frequency.txt
report_area > area_low_frequency.txt

# Netlist and constraint file export
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/IIRFilter.sdf
write -f verilog -hierarchy -output ../netlist/IIRFilter.v
write_sdc ../netlist/IIRFilter.sdc



