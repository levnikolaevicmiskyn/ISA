#!/bin/bash

#initialize environment
source /software/scripts/init_synopsys_64.18

#convert file
vcd2saif -input ../vcd/IIRFilter.vcd -output ../saif/IIRFilter.saif
