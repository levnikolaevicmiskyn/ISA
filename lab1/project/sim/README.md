# Behavioral simulation and verification:

## Inputs generation
The inputs are generated using vertools. First you need to configure the input section in **vertools.config**:

>[Input]  
>file = samples.txt

it is the file where your waveform will be saved

>tstart = 0ms

it is the start time of your generated waveform  

>tend = 1s

it is the end time of your generated waveform  

>tstep = 1ms

it is the step time of your generated waveform, gives the sampling frequency as 1/tstep

The total number of generated samples will be (tend - tstart)/tstep

Once you have set those parameters you can call vertools for generating your waveform:

`$ vertools generate-inputs constant {value}`  
Generate a constant value input

`$ vertools generate-inputs sine {amplitude} {frequency} {phase}`  
Generate a sine waveform with given amplitude frequency and phase in radians  
To avoid undersampling your frequency should be lower than 1/(2*tstep)

`$ vertools generate-inputs chirp {amplitude} {duration} {f0} {f1} [--method {linear,quadratic,logarithmic,hyperbolic}]`  
Generate a chirp waveform  with given amplitude from frequency f0 to frequency f1  
The duration is the instant at which the chirp reaches its final frequency   
To avoid undersampling your f0,f1 should be lower than 1/(2*tstep)  
The optional --method parameter let you change the chirp generation method

Add '--help' at any point of the command for specific help, as in:  
`$ vertools --help` Will describe vertools command  
`$ vertools generate-inputs --help` Will describe generate-inputs parameters  
`$ vertools generate-inputs sine --help` Will describe sine wave parameters

Most parameters are read by default from **vertools.config** file, but you can specify your own with the appropriate flags in each command


## Simulation
The simulation is managed by vertools. First you need to configure the simulate section in **vertools.config**:

>[Simulation]  
 >command = source ./**simulate_fast.do** "${Simulation:duration}"

you need to set the proper .do file:
- **simulate_[standard|fast].do** for vhdl simulation
- **post_synth_simulate_[standard|fast].do** for post synthesis verification and power back-annotation
- **post_place_route_simulate_[standard|fast].do** for post place and route verification and power back-annotation

>setup = source /software/scripts/init_msim6.2g  
>log = log-sim.txt  
>results = results-VHDL.txt  
>disable_log = false  
>clock = 10ns  
>tstart = 0ns  
>tend = 20us  	

you need to modify tend accordingly with the number of samples you have generated. The clock period should not be touched. tend must be at least (N_samples + 100)* clock. A longer time is not a problem.
>tstep = 1ns  
>duration = ${Simulation:tend}

Once you have set those parameters you can call vertools for launching your simulation:

`$ vertools simulate`


## Reference
The output reference generation is managed by vertools. First you need to compile the program you need:

`$ make cfilter.out`  
for the standard architecture

 `$ make cfilter_fast.out`  
 for the fast architecture

Then you need to configure the reference section in **vertools.config**:

>[Reference]
>command = ./**cfilter_fast.out** "${Input:file}" "${Reference:results}" 	

you need to set the proper reference program:
- **cfilter_fast.out** for fast architecture
- **cfilter.out for** for standard architecture

>log = log-ref.txt  
>results = results-C.txt  
>disable_log = false  
>tstart = ${Simulation:tstart}  
>tend = ${Simulation:tend}  
>tstep = ${Simulation:tstep}

Once you have set those parameters you can call vertools for launching your output reference generation:

`$ vertools reference`


## Comparison

The results comparison is managed by vertools:

`$ vertools compare`

## Tips and Tricks

If you want to perform **Simulation**, **Reference** and **Comparison** up to ones first generate the inputs and then you can call vertools with:

`$ vertools verify`
