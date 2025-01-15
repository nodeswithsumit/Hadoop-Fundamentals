# mapper.py
import sys

for line in sys.stdin:
    # Remove leading/trailing whitespace
    line = line.strip()

    # Split the line into year, month, and consumption
    try:
        year, month, consumption = line.split(',')
        consumption = int(consumption)  # Convert consumption to an integer
        # Emit the year and consumption
        print(f"{year}\t{consumption}")
    except ValueError:
        # Skip lines with incorrect format
        continue
