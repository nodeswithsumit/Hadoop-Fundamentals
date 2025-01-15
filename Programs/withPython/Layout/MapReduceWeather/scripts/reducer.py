
# reducer.py
import sys

current_classification = None
current_count = 0

for line in sys.stdin:
    # Remove leading/trailing whitespace
    line = line.strip()

    # Parse the input from the mapper
    try:
        classification, date = line.split('\t')

        if current_classification == classification:
            current_count += 1
        else:
            if current_classification is not None:
                # Emit the count for the previous classification
                print(f"{current_classification}\t{current_count}")
            # Start counting the new classification
            current_classification = classification
            current_count = 1
    except ValueError:
        # Skip lines with incorrect format
        continue

# Emit the last classification
if current_classification is not None:
    print(f"{current_classification}\t{current_count}")
