# reducer.py
import sys

current_year = None
max_consumption = 0

for line in sys.stdin:
    # Remove leading/trailing whitespace
    line = line.strip()

    # Parse the input from the mapper
    try:
        year, consumption = line.split('\t')
        consumption = int(consumption)

        if current_year == year:
            # Update max consumption for the current year
            max_consumption = max(max_consumption, consumption)
        else:
            if current_year is not None:
                # Emit the maximum consumption for the previous year
                print(f"{current_year}\t{max_consumption}")
            # Start processing the new year
            current_year = year
            max_consumption = consumption
    except ValueError:
        # Skip lines with incorrect format
        continue

# Emit the last year
if current_year is not None:
    print(f"{current_year}\t{max_consumption}")
