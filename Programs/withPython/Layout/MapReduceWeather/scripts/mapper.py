
# mapper.py
import sys

SHINY_THRESHOLD = 8  # Sunshine hours threshold for a shiny day
COOL_THRESHOLD = 15  # Temperature threshold for a cool day

for line in sys.stdin:
    # Remove leading/trailing whitespace
    line = line.strip()

    # Split the line into date, temperature, and sunshine hours
    try:
        date, temperature, sunshine_hours = line.split(',')
        temperature = float(temperature)
        sunshine_hours = float(sunshine_hours)

        # Classify the day
        if sunshine_hours > SHINY_THRESHOLD:
            print(f"Shiny\t{date}")
        elif temperature < COOL_THRESHOLD:
            print(f"Cool\t{date}")
    except ValueError:
        # Skip lines with incorrect format
        continue
