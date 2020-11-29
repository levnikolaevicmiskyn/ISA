echo "Removing old files"
rm -rf work
rm results.hex
echo "Initializing ModelSim"
source /software/scripts/init_msim6.2g
echo "Running simulation (100 us)"
source simulate_MBE_24bit.do 100us > log-sim.txt
echo "Check log-sim.txt"
echo "Comparing results..."
diff results.hex fp_prod.hex -Z -b -i -s
