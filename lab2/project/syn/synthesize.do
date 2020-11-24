remove_design -designs

# Analyze source files
analyze -f vhdl -lib WORK ../src/common/fpnormalize_fpnormalize.vhd
analyze -f vhdl -lib WORK ../src/common/packfp_packfp.vhd
analyze -f vhdl -lib WORK ../src/common/fpround_fpround.vhd
analyze -f vhdl -lib WORK ../src/common/unpackfp_unpackfp.vhd
analyze -f vhdl -lib WORK ../tb/simconsts.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage1_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage2_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage3_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage4_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_pipeline_wregs.vhd


# Elaborate

set power_preserve_rtl_hier_names true
elaborate fpmul -arch pipeline -lib WORK


# Create clock 
create_clock -name clk -period 0 {clk}
set_dont_touch_network clk

# Flatten the hierarchy
ungroup -all -flatten

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks clk]
set_input_delay 0.5 -max -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]


# Compile
compile

report_resources > reports/multiplier_pipeline/report_resources.txt
report_area > reports/multiplier_pipeline/report_area_max_freq.txt
report_timing > reports/multiplier_pipeline/report_timing_max_freq.txt


### Synthesize after implementing stage2 with a CSA
remove_design -designs

# Elaborate

set power_preserve_rtl_hier_names true
elaborate fpmul -arch pipeline -lib WORK


# Create clock 
create_clock -name clk -period 0 {clk}
set_dont_touch_network clk

# Flatten the hierarchy
ungroup -all -flatten

set_implementation DW02_mult/csa [find cell *mult*]

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks clk]
set_input_delay 0.5 -max -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

compile

report_resources > reports/multiplier_pipeline_CSA/report_resources.txt
report_area > reports/multiplier_pipeline_CSA/report_area.txt
report_timing > reports/multiplier_pipeline_CSA/report_timing.txt

### Synthesize after implementing stage2 with a PPARCH
remove_design -designs

# Elaborate

set power_preserve_rtl_hier_names true
elaborate fpmul -arch pipeline -lib WORK


# Create clock 
create_clock -name clk -period 0 {clk}
set_dont_touch_network clk

# Flatten the hierarchy
ungroup -all -flatten

set_implementation DW02_mult/pparch [find cell *mult*]

# Set uncertainties and synthesis variables
set_clock_uncertainty 0.07 [get_clocks clk]
set_input_delay 0.5 -max -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

compile

report_resources > reports/multiplier_pipeline_pparch/report_resources.txt
report_area > reports/multiplier_pipeline_pparch/report_area.txt
report_timing > reports/multiplier_pipeline_pparch/report_timing.txt
