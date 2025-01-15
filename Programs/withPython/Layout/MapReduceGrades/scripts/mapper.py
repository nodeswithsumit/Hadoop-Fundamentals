#!/usr/bin/env python3
import sys

for line in sys.stdin:
    # Strip leading/trailing whitespace
    line = line.strip()

    # Split the line into fields
    fields = line.split(',')

    # Ensure we have exactly four fields
    if len(fields) == 4:
        student_id = fields[0].strip()
        score = fields[3].strip()
        try:
            score = int(score)
            # Emit StudentID and Score
            print(f"{student_id}\t{score}")
        except ValueError:
            # Skip invalid score entries
            continue
