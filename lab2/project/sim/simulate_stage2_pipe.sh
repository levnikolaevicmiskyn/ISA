echo "Removing old files..."
rm -rf work
echo "Initializing modelsim"
source /software/scripts/init_msim6.2g
vlib work
echo "Running simulation (100 us)"
source simulate_stage2_pipe.do 100us
echo "Comparing results..."
diff results.hex fp_prod.hex -i -b -Z -s
