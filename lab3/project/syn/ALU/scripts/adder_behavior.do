# Clear design
remove_design -designs

# Analyze components
analyze -f vhdl -lib WORK ../../src/ALU/adder_behavior.vhd

# Elaborate
elaborate adder -arch behavior -lib WORK

# Compile
compile > reports/compilation/adder_behavior.txt

# Save reports
report_timing > reports/timing/adder_behavior.txt
report_area > reports/area/adder_behavior.txt
