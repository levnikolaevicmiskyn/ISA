echo "Verification of 1.1: pipelining by means of additional input registers"
echo "Removing folder work..." 
rm -rf work
echo "Initializing ModelSim..."
source /software/scripts/init_msim6.2g
vlib work
echo "Running simulate_base.do for 100 us"
source simulate_base.do 100us
echo "Comparing results..."
diff results.hex fp_prod.hex -i -b -Z -s
