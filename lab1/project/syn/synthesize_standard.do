# Clear design
remove_design -designs

# Analyze components
analyze -f vhdl -lib WORK ../src/fpconv.vhd
analyze -f vhdl -lib WORK ../src/constants.vhd
analyze -f vhdl -lib WORK ../src/packets.vhd
analyze -f vhdl -lib WORK ../src/multiplier.vhd
analyze -f vhdl -lib WORK ../src/adder.vhd
analyze -f vhdl -lib WORK ../src/controlUnit_standard.vhd
analyze -f vhdl -lib WORK ../src/Datapath_standard.vhd
analyze -f vhdl -lib WORK ../src/IIRFilter.vhd


### Max Frequency Analysis ###

# Elaborate
set power_preserve_rtl_hier_names true
elaborate IIRFilter -arch RTL -lib WORK

# Setup clock
create_clock -name CLK -period 2.74 {CLK}
set_dont_touch_network CLK

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Compile
compile > reports/hf/compile_report.txt

# Save reports
report_timing > reports/hf/timing_report.txt
report_area > reports/hf/area_report.txt


### Synthesis At Lower Frequency (without clock gating)###

# Clear design
remove_design -designs

# Elaborate
set power_preserve_rtl_hier_names true
elaborate IIRFilter -arch RTL -lib WORK > reports/lf/elaborate_result.txt

# Setup clock (4Tmin)
create_clock -name CLK -period 11 {CLK}
set_dont_touch_network CLK

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Run check_design to report potential problems (warnings)
check_design > reports/lf/check_design.txt

# Compile
compile > reports/lf/compile_result.txt

# Save reports
report_timing > reports/lf/timing_report.txt
report_area > reports/lf/area_report.txt

# Netlist and constraint file export
ungroup -all -flatten
change_names -hierarchy -rules verilog
# sdf file containing the delay of the netlist
write_sdf ../netlist/IIRFilter.sdf
# Save the netlist in Verilog
write -f verilog -hierarchy -output ../netlist/IIRFilter.v
# sdc file containts constraints to the input and output ports in a standard format
write_sdc ../netlist/IIRFilter.sdc


### Synthesis at lower frequency (with clock gating) ###
# Clear design
remove_design -designs

# Elaborate
set power_preserve_rtl_hier_names true
elaborate IIRFilter -arch RTL -lib WORK

# Setup clock
create_clock -name CLK -period 11 {CLK}
set_dont_touch_network CLK

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Run check_design to report potential problems (warnings)
check_design

# Compile
compile -gate_clock > reports/lf/compile_result_gateck.txt

# Save reports
report_timing > reports/lf/timing_report_gateck.txt
report_area > reports/lf/area_report_gateck.txt
