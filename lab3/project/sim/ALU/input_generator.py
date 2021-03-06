import sys
import random

nsamples = int(sys.argv[1])

operations = {
    'sum': 0,
    'shift': 1,
    'and': 2,
    'xor': 3
}

for i in range(nsamples):
    operand1 = random.randint(0, 2**32 - 1)
    operand2 = random.randint(0, 2**32 - 1)
    operation = random.choice(list(operations.keys()))
    print(f"{operand1:0>8x} {operand2:0>8x} {operations[operation]:0>1x}")
