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
    status = subprocess.run(command, shell=True, stdout=stdout, stderr=stderr)
    return status


def run_simulation(duration, simulation_script):
    duration = f"{int(duration/1e-9)} ns"
    # Delete work folder
    delete_folder = "rm -rf ./work/"
    run_bash(delete_folder)
    # Run simulation
    simulation_command = f"source /software/scripts/init_msim6.2g && " \
                         f"source {simulation_script} \"{duration}\" |& sed 's/^/    /'"
    status = run_bash(simulation_command)
    return status


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


def compare_results(file_c, file_vhdl, threshold):
    """Compare simulation results.
    Args:
        file_c (file): reference results
        file_vhdl (file): simulation results
        threshold (int): minimum error to consider a failure
    Return:
        int: exit code
    """
    # Check file lengths
    lenc = sum(1 for line in file_c)
    lenv = sum(1 for line in file_vhdl)
    if lenc != lenv:
        print(f"  Files differ in length: C = {lenc}; VHDL = {lenv}")
        return 2
    # Compare numerical results
    for line, (resc, resv) in enumerate(zip(file_c, file_vhdl)):
        resc = int(resc)
        resv = int(resv)
        if abs(resc - resv) > threshold:
            print(f"  Threshold crossed on line {line}: C = {resc}; VHDL = {resv}")
            return 3
    return 0


def color(string, code):
    """Surround a string with ANSI escape sequences to color outputs.
    Args:
        string (str): string to be decorated
        code (str): either code name or ANSI escape sequence

    """
    code = CODES[code] if code in CODES else code
    return code + string + CODES['ENDC']


def status_update(status, error=''):
    """Wrapper to decorate outputs with colors and status updates.
    Args:
        status (str): message for status enetring
        error (str): generic error message
    Return:
        function: wrapped function
    """

    def decorate(func):
        def decorated_func(*args, **kwargs):
            print(color(status, 'OKBLUE'))
            code = func(*args, **kwargs)
            if code != 0:
                print(color(f"  ERROR: {error}", 'FAIL'))
                exit(code)
            else:
                print(color("  Done!", 'OKGREEN'))

        return decorated_func

    return decorate


def main():
    """Main function"""
    time = None
    input_duration = 500e-3
    input_delta = 1 / 10e3
    input_nsamples = input_duration / input_delta

    clock_period = 10e-9
    simulation_duration = (30 + input_nsamples) * clock_period

    # Clean simulation related files
    @status_update("Cleaning files...")
    def _clean_files():
        try:
            os.remove("./samples.txt")
            os.remove("./results-C.txt")
            os.remove("./results-VHDL.txt")
        except OSError:
            pass
        return 0

    _clean_files()

    # Generate time ans input samples
    @status_update("Generating inputs...")
    def _generate_inputs():
        nonlocal time
        time = np.arange(0.0, input_duration + input_delta, input_delta)
        inputs = generate_inputs(time, 127)
        # Store samples in a file
        np.savetxt('samples.txt', inputs, fmt='%d')
        return 0

    _generate_inputs()

    # Launch reference filter
    @status_update("Compiling and running C filter...", "Error: C filter could not be compiled or launched")
    def _reference():
        status = run_reference('./cfilter.out', 'samples.txt', 'results-C.txt')
        return status.returncode

    _reference()

    # Launch VHDL simulation
    @status_update("Simulating VHDL...", "Simulation unsuccesful")
    def _simulate():
        nonlocal time
        status = run_simulation(simulation_duration, './simulate.do')
        return status.returncode

    _simulate()

    # Check simulation results
    @status_update("Checking results...", "Results mismatch")
    def _check_results():
        with open("results-C.txt", 'r') as file_c, open("results-VHDL.txt", 'r') as file_vhdl:
            return compare_results(file_c, file_vhdl, 0)

    _check_results()


if __name__ == '__main__':
    main()
