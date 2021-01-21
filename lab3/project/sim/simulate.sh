#!/bin/bash
# Check arguments
if (( $#!= 1 ))
then
	echo "Please specify which simulate script you want to execute"
	exit 1
fi
# Check if requested script exists
script=$1
if [[ ! -f "$script" ]]
then
	echo "Script $script does not exist"
	exit 2
fi
# Clean directory
rm -rf work/

# Launch script
echo "Initializing Modelsim..."
source /software/scripts/init_msim6.2g
echo "Done"
echo "Starting simulation"
vsim -c -do "source $script">log.txt
echo "Done"
exit 0