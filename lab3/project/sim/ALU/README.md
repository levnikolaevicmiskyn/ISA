# ALU simulator
This executable is used as a software reference to check the results from the hardware implementation

## Compilation
For a tidy compilation, if a __build__ directory is not present, `mkdir build`. 
Then:
```shell script
$ cd build
$ cmake ..
```
## Usage
To launch the executable, run
```shell script
$ build/ALU
```
### Direct usage
The program, by default, reads inputs from the standard input and prints outputs to the standard output. This way, the 
user can run operations directly from the command line and directly see the results. All the inputs should follow the 
[input format](#input-format).

To terminate the program, simply press Ctrl+D or Ctrl+C.

### Input files
It is possible to use pipes or redirect inputs and outputs from and to other files with the usual bash syntax. In a full example:
```shell script
$ build/ALU < inputs.txt > outputs.txt
```
Or, for a pipe
```shell script
$ python3 input_generator 10 | build/ALU > outputs.txt
```
This way, the inputs will be read from 'inputs.txt' and the outputs will be stored in 'outputs.txt'

## Input format
Every line must contain all the inputs of the ALU for a given clock cycle, even when they are not needed for a certain 
operation. The inputs must be in the __hex__ format and __separated by spaces__. The order is:
1. ALU_opcode
2. operator1
3. operator2
4. immediate
5. source

For example:
```
0 00000000 11111111 ffffffff 0
```
Represents a sum (`ALU_opcode = 0`) between `operator1 = 00000000` and `operator2 = 11111111` (because `source = 0`, 
`immediate` is ignored) and will return `11111111`.