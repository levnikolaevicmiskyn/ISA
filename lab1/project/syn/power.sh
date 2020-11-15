#!/bin/bash

echo "Initializing synopsis..." 
source /software/scripts/init_synopsys_64.18

echo "Converting vcd file..."
vcd2saif -input ../vcd/IIRFilter.vcd -output ../saif/IIRFilter.saif

script="pwr_back_ann.do"
echo "Running power back-annotation script $script..."

dc_shell-xg-t -x "source $script; exit" > log-power.txt
echo "Logs saved in log-power.txt"
echo "Done"

