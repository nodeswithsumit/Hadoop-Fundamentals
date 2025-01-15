#!/usr/bin/env python3
import sys

current_student = None
total_score = 0
subject_count = 0

# Function to calculate grade based on score
def calculate_grade(score):
    if 90 <= score <= 100:
        return "A"
    elif 80 <= score < 90:
        return "B"
    elif 70 <= score < 80:
        return "C"
    elif 60 <= score < 70:
        return "D"
    else:
        return "F"

for line in sys.stdin:
    # Strip leading/trailing whitespace
    line = line.strip()

    # Parse input from mapper
    student_id, score = line.split('\t', 1)
    score = int(score)

    # If processing a new student
    if current_student != student_id:
        if current_student is not None:
            # Calculate average and grade for the previous student
            average_score = total_score // subject_count
            grade = calculate_grade(average_score)
            print(f"{current_student}\t{average_score}\t{grade}")
        # Reset variables for the new student
        current_student = student_id
        total_score = score
        subject_count = 1
    else:
        # Accumulate scores for the same student
        total_score += score
        subject_count += 1

# Output for the last student
if current_student is not None:
    average_score = total_score // subject_count
    grade = calculate_grade(average_score)
    print(f"{current_student}\t{average_score}\t{grade}")
