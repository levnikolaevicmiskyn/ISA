**Part 1: digital arithmetic and logic synthesis**
*fpmul_pipeline.vhd*: Unmodified version of the floating point multiplier

*fpmul_pipeline_wregs.vhd*: Floating point multiplier with additional input registers, parametrized by *NPIPE*

*fpmul_stage2_struct*: Unmodified version of the second stage within the multiplier

*/tb/simconsts.vhd*: Used to define NPIPE in the basic case, without the hardcoded stage 2 register (see README in project)

**Part 2: Fine grain pipelining and optimization**
*fpmul_stage2_struct_pipelined*: Stage 2 with one pipeline register manually added

*/tb/simconsts_stage2_pipelined.vhd*: Used to define NPIPE where stage 2 contains an additional hardcoded register (see README in project)

**Part 3: MBE**
*fpmul_stage2_MBE_24bit*: Stage 2 of multiplier using a 24 bit MBE multiplier instead of the DesignWare component. This is **without** the pipeline register added manually!

*fpmul_pipeline_wregs.vhd*: The MBE is synthesized in combination to a parametrized number of pipeline registers (*NPIPE* as defined in *tb/simconsts.vhd*).

*tb/simconsts.vhd*

*tb/simconsts_NPIPE2.vhd*

*tb/simconsts_NPIPE4.vhd*

