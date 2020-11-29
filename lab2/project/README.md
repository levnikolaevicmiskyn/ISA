**Part 1**

**Additional input registers: verification**

The number of additional pipe registers is NPIPE, defined in *tb/simconsts.vhd*, defaults to 1
- Run sim/simulate_base.sh

**Additional input registers: synthesis**

This version will be synthesized with three different implementations for the stage 2 multiplier (default, CSA, pparch), using cells that are already available in the DesignWare library.
The number of additional pipeline registers in NPIPE, defined in *tb/simconsts.vhd*, defaults to 1
- Run syn/synthesize.sh
- Results available in *reports/multiplier_pipeline[_{CSA, pparch}]*


**Part 2**

In this part one pipeline register is added manually in stage 2. The number of input pipeline registers is specified in *tb/simconsts_stage2_pipelined.vhd*.

**Stage 2 pipeline register: verification**

- Run *sim/simulate_stage2_pipe.sh*

**Stage 2 pipeline register: synthesis**

- Run *syn/synthesize_stage2_pipe.sh*
- Read results

**Part 3: MBE**

In this part the multiplier in stage 2 is implemented using MBE. The number of input pipeline registers is specified in *tb/simconsts.vhd*.

**Verification**

- Run sim/simulate_MBE.sh

**Synthesis**

This design is synthesized in the following flavors:
- No *optimize_register*: reports available in *reports/multiplier_MBE*
- NPIPE = 1 and *optimize_register*: reports available in *reports/multiplier_MBE/[...]_opt_reg.txt*
- NPIPE = 2 and *optimize_register*: reports available in *reports/multiplier_MBE/[...]_opt_reg_npipe2.txt*
- NPIPE = 4 and *optimize_register*: reports available in *reports/multiplier_MBE/[...]_opt_reg_npipe4.txt*
- Run syn/synthesize_MBE.sh

