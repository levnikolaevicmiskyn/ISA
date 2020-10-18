import numpy as np
import scipy.signal as signal

import subprocess
import os

CODES = {
    'HEADER': '\033[95m',
    'OKBLUE': '\033[94m',
    'OKCYAN': '\033[96m',
    'OKGREEN': '\033[92m',
    'WARNING': '\033[93m',
    'FAIL': '\033[91m',
    'ENDC': '\033[0m',
    'BOLD': '\033[1m',
    'UNDERLINE': '\033[4m'
}


def generate_inputs(time, scale):
    """Generate the simulation inputs.
    Args:
        time (numpy.array): time array for the simulation
        scale (int): sample scaling factor for SFP representation
    Return:
        numpy.array: simulation samples
    """
    t1 = time[-1]
    f0 = 10
    f1 = 5000

    def chirp(t):
        return signal.chirp(t, f0, t1, f1, method='logarithmic')

    # Convert all samples to integer
    inputs = chirp(time) * scale
    inputs = inputs.astype(int)
    return inputs


def run_bash(command, **kwargs):
    """Run a bash command
    Args:
        command (str): command to be executed
        **kwargs: arbitrary keyword arguments
    Return:
    """
    stdout = kwargs.get('stdout', None)
    stderr = kwargs.get('stderr', None)
    status = subprocess.run(command, shell=True, text=True, stdout=stdout, stderr=stderr)
    return status


def run_simulation(time, simulation_script):
    duration = time[-1]
    duration = f"{time:.1e} s"
    simulation_command = f"SIMULATION_TIME={duration};" \
                         f""
    raise NotImplementedError()


def run_reference(executable, samples, results):
    """Run the reference software version of the filter, written in C.
    Args:
        executable (str): name of the C executable
        samples (str): name of samples file
        results (str): name of the output file
    Return:
       subprocess.CompletedProcess: process associated to the command
    """
    command = f'make; {executable} "{samples}" "{results}"'
    status = run_bash(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return status


def color(string, code):
    """Surround a string with ANSI escape sequences to color outputs.
    Args:
        string (str): string to be decorated
        code (str): either code name or ANSI escape sequence

    """
    code = CODES[code] if code in CODES else code
    return code + string + CODES['ENDC']


def status_update(status, error=''):
    def decorate(func):
        def decorated_func(*args, **kwargs):
            print(color(status, 'OKBLUE'))
            code = func(*args, **kwargs)
            if code != 0:
                print(color(error, 'ERROR'))
                exit(code)
            else:
                print(color("  Done!", 'OKGREEN'))
        return decorated_func
    return decorate


def main():
    time = None
    
    # Generate time ans input samples
    @status_update("Generating inputs...")
    def makeinputs():
        nonlocal time
        time = np.arange(0.0, 10, 1 / 20)
        inputs = generate_inputs(time, 128)
        # Store samples in a file
        np.savetxt('samples.txt', inputs, fmt='%d')
        return 0
    makeinputs()

    # Launch reference filter
    @status_update("Compiling and running C filter...", "Error: C filter could not be compiled or launched")
    def reference():
        status = run_reference('./cfilter.out', 'samples.txt', 'results-C.txt')
        return status.returncode
    reference()

    # Launch VHDL simulation
    @status_update("Simulating VHDL...", "Error: Simulation unsuccesfull")
    def simulate():
        nonlocal time
        status = run_simulation(time, 'simulate.do')
        return status.returncode
    simulate()



if __name__ == '__main__':
    main()
