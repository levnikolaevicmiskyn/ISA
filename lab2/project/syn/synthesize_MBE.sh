#!/bin/bash
echo "Cleaning work directory"
rm -rf work
mkdir work

echo "Initializing synopsys"
source /software/scripts/init_synopsys_64.18

echo "Running synthesis script"
dc_shell-xg-t -x "source synthesize_MBE.do > log_MBE.txt; source synthesize_MBE_optreg.do > log_MBE_optreg.txt; source synthesize_MBE_optreg_NPIPE2.do > log_MBE_optreg_NPIPE2.txt; source synthesize_MBE_optreg_NPIPE4.do > log_MBE_optreg_NPIPE4.txt; exit"
echo "Done!"
