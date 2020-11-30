echo "Synthesis of 1.1: pipelining by means of additional input registers"
echo "Removing old files..."
rm -rf work
echo "Initializing Synopsys..."
source /software/scripts/init_synopsys_64.18
echo "Running synthesis script..."
dc_shell-xg-t -x "source synthesize.do; exit" > log-synth-standard.txt
echo "Results available in reports/multiplier_pipeline/, reports/multiplier_pipeline_CSA, reports/multiplier_pipeline_pparch"
