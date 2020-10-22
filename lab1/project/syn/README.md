Synthesis:

- open a shell
- type "mkdir work"
- type "source /software/scripts/init_synopsys_64.18"
- type "dc_shell-xg-t"
- once synopsys is opened type "source synthesize.do"
- once finished type "exit"


Verification and Power back-annotation (Synthesis is mandatory first)

- go in folder sim and run simulate.py with post_synth_simulate.do as .do file
- go back in this folder
- type "chmod u+x vcd2saif.sh"
- type "./vcd2saif.sh"
- type "source /software/scripts/init_synopsys_64.18"
- type "dc_shell-xg-t"
- once synopsys is opened type "pwr_back_ann.do"
- once finished type "exit"

