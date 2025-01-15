# reducer.py
import sys

current_year = None
max_temperature = None

for line in sys.stdin:
    # Remove leading and trailing whitespace
    line = line.strip()

    # Parse the input from the mapper
    year, temperature = line.split('\t', 1)
    temperature = int(temperature)

    # If we're processing a new year
    if current_year != year:
        if current_year is not None:
            # Output the max temperature for the previous year
            print(f"{current_year}\t{max_temperature}")
        # Reset variables for the new year
        current_year = year
        max_temperature = temperature
    else:
        # Update the max temperature for the current year
        max_temperature = max(max_temperature, temperature)

# Output the max temperature for the last year
if current_year is not None:
    print(f"{current_year}\t{max_temperature}")