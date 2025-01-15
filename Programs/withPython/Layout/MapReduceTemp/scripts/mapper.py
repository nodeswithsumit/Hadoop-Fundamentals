# mapper.py
import sys

for line in sys.stdin:
    # Remove leading and trailing whitespace
    line = line.strip()

    # Split the line into fields
    fields = line.split(',')

    # Ensure we have exactly four fields
    if len(fields) == 4:
        year = fields[0].strip()  # First column is the year
        try:
            temperature = int(fields[3].strip())  # Fourth column is the temperature
            # Emit the year and temperature
            print(f"{year}\t{temperature}")
        except ValueError:
            # Skip rows with invalid temperature values
            continue