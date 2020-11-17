# Restore design
source IIRFilter.enc

# Recover parasitcs
reset_parasitics
extractRC
rcOut -setload IIRFilter.setload -rc_corner my_rc
rcOut -setres IIRFilter.setres -rc_corner my_rc
rcOut -spf IIRFilter.spf -rc_corner my_rc
rcOut -spef IIRFilter.spef -rc_corner my_rc

# Power estimation
set_power_analysis_mode -reset
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir ./
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
read_activity_file -format VCD -scope testbench/comp_IIRFilter -start {} -end {} -block {} ../vcd/design.vcd
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile .//IIRFilter.power.rail.rpt
report_power -outfile IIRFilter.power.rpt -clock_network { CLK } -count_seq_elements_in_clock_network -instances { /testbench/comp_IIRFilter } -hierarchy all -cell_type all -power_domain all -pg_net all -net -sort { total }
