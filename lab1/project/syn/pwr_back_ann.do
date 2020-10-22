# Import netlist
read_verilog -netlist ../netlist/IIRFilter.v

# Import saif file
read_saif -input ../saif/IIRFilter.saif -instance_name testbench/comp_IIRFilter -unit ns -scale 1

# Clock creation
create_clock -name CLK {CLK}

# Power report
report_power > power_low_frequency.txt
