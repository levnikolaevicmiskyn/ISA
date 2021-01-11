#!/bin/bash
# Determine simulation size
if (( $# < 1 ))
then
    ninputs=100
    echo "No simulation size specified. Using default value."
else
    ninputs=$1
fi
echo "Generating $ninputs inputs"
python3 input_generator.py $ninputs > inputs.txt

echo "Running simulation"
rm -rf work/
source /software/scripts/init_msim6.2g
source scripts/ALU.do > log.txt

echo "Running reference"
build/ALU < inputs.txt > results-CPP.txt

echo "Done!"
rm -rf inputs.txt
exit 0
