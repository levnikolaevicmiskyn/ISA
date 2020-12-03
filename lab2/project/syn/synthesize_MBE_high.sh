#!/bin/bash
echo "Cleaning work directory"
rm -rf work
mkdir work

echo "Initializing synopsys"
source /software/scripts/init_synopsys_64.18

echo "Running synthesis script"
dc_shell-xg-t -x "source synthesize_MBE_optreg_NPIPE6.do > log_MBE_optreg_NPIPE6.txt; source synthesize_MBE_optreg_NPIPE8.do > log_MBE_optreg_NPIPE8.txt; exit"
echo "Done!"
