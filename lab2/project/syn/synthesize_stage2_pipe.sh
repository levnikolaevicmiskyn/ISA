echo "Removing old folder"
rm -rf work
echo "Initializing Synopsys..."
source /software/scripts/init_synopsys_64.18

echo "Running synthesis script (NPIPE=1)..."
mkdir work
dc_shell-xg-t -x "source synthesize_stage2_pipe.do; exit" > log-synth_NPIPE1.txt
echo "Results available in reports/multiplier_stage2_pipelined"

echo "Running synthesis script (NPIPE=2)..."
rm -rf work
mkdir work
dc_shell-xg-t -x "source synthesize_stage2_pipe_NPIPE2.do; exit" > log-synth_NPIPE2.txt
echo "Results available in reports/multiplier_stage2_pipelined_NPIPE2"

echo "Running synthesis script (NPIPE=4)..."
rm -rf work
mkdir work
dc_shell-xg-t -x "source synthesize_stage2_pipe_NPIPE4.do; exit" > log-synth_NPIPE4.txt
echo "Results available in reports/multiplier_stage2_pipelined_NPIPE4"

echo "Running synthesis script (NPIPE=6)..."
rm -rf work
mkdir work
dc_shell-xg-t -x "source synthesize_stage2_pipe_NPIPE6.do; exit" > log-synth_NPIPE6.txt
echo "Results available in reports/multiplier_stage2_pipelined_NPIPE6"
