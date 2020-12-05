#!/bin/bash
# Check arguments
if (( $#!= 1 ))
then
	echo "Please specify which synthesis script you want to execute"
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
mkdir work
# Launch script
echo "Initializing Synopsys..."
source /software/scripts/init_synopsys_64.18
echo "Done"
echo "Starting synthesis..."
dc_shell-xg-t -x "source \"$script\"; exit" > log.txt
echo "Done"
exit 0
