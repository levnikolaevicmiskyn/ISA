# Clear design
remove_design -designs

# Analyze components
analyze -f vhdl -lib WORK ../src/ALU/barrelShifter_behavior.vhd

# Elaborate
elaborate barrelShifter -arch behavior -lib WORK

# Compile
compile > reports/compilation/barrelShifter_behavior.txt

# Save reports
report_timing > reports/timing/barrelShifter_behavior.txt
report_area > reports/area/barrelShifter_behavior.txt
