# Clear design
remove_design -design

# Analyze components
analyze -f vhdl -lib WORK ../src/fpconv.vhd
analyze -f vhdl -lib WORK ../src/multiplier.vhd
analyze -f vhdl -lib WORK ../src/adder.vhd
analyze -f vhdl -lib WORK ../src/controlUnit.vhd
analyze -f vhdl -lib WORK ../src/Datapath.vhd
analyze -f vhdl -lib WORK ../src/IIRFilter.vhd

# Elaborate
set power_preserve_rtl_hier_names true
elaborate IIRFilter -arch RTL -lib WORK

# Setup clock
create_clock -name CLK -period 10 {CLK}
set_dont_touch_network CLK

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Compile
compile
