Synthesis:
- open a shell
- type "rm -rf work"
- type "mkdir work"
- type "source /software/scripts/init_synopsys_64.18"
- type "dc_shell-xg-t"
- once synopsys is opened type "source synthesize_[standard|fast].do"
- once finished type "exit"

2020/10/24: Changes in synthesize.do: 
-removed unnecessary flag -gate_clock
-Organized reports in dedicated folders


Verification and Power back-annotation (Synthesis is mandatory first)

- open a shell
- go in folder sim and run simulate.py with post_synth_simulate_[standard|fast].do as .do file
- go back in this folder
- type "chmod u+x vcd2saif.sh"
- type "./vcd2saif.sh"
- type "source /software/scripts/init_synopsys_64.18"
- type "dc_shell-xg-t"
- once synopsys is opened type "source pwr_back_ann.do"
- once finished type "exit"



