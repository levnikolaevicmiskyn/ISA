#!/bin/bash
arch="$1"
if (( $#<1 ))
then
  echo "Please choose architecture (standard/fast)"
  exit 1
fi

if [[ !($arch =~ (standard|fast)) ]]
then
  echo "Please choose a valid architecture."
  exit 1
fi

echo "Cleaning work directory..."
rm -rf work
mkdir work

echo "Initializing synopsis..." 
source /software/scripts/init_synopsys_64.18

script="synthesize_${arch}.do"
echo "Running synthesis script $script..."
dc_shell-xg-t -x "source $script; exit" > log-synth.txt
echo "Logs saved in log-synth.txt"
echo "Done"
