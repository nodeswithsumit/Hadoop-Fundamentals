# reducer.py
import sys
from collections import defaultdict

current_key = None
values = defaultdict(list)

for line in sys.stdin:
    line = line.strip()
    key, value = line.split('\t')
    matrix, index, element_value = value.split(',')

    index = int(index)
    element_value = float(element_value)

    if current_key == key:
        values[matrix].append((index, element_value))
    else:
        if current_key is not None:
            # Calculate partial sum for the previous key
            result = 0
            for a_index, a_value in values['A']:
                for b_index, b_value in values['B']:
                    if a_index == b_index:
                        result += a_value * b_value
            print(f"{current_key}\t{result}")

        # Reset for the new key
        current_key = key
        values = defaultdict(list)
        values[matrix].append((index, element_value))

# Final key
if current_key is not None:
    result = 0
    for a_index, a_value in values['A']:
        for b_index, b_value in values['B']:
            if a_index == b_index:
                result += a_value * b_value
    print(f"{current_key}\t{result}")
