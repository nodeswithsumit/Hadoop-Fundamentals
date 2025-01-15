# Develop a MapReduce program to find the grades of student’s.

Using Python, we can implement the same logic for finding the grade obtained by the student using the Hadoop Streaming API for MapReduce. Below is how you can approach this problem with a Python MapReduce program.

We want to calculate the grades of student based on their total scores. Teh Grade rules: 

* 90-100 : A
* 80-89  : B
* 70-79  : C
* 60-69  : D
* Below 60 : F

Note: The InputFile should contain student records, where each line is structures as : 

```bash
StudentID, StudentName,Subject,Score
```

## Prepare Folder Structure

```graphql
MapReduceGrades/
├── input/
│   └── grades_data.txt   # Input data file
├── scripts/
│   ├── mapper.py              # Mapper script
│   ├── reducer.py             # Reducer script
├── output/                    # (Optional) Local output folder for testing
```

## Steps to Set Up in VS Code

### Create the Project Folder:

* Open VS Code.
* Create a new folder named MapReducePython or any name you prefer.
* Open this folder in VS Code (File > Open Folder).

### Organize the Files:

* Inside the project folder, create the subdirectories input, scripts, and output (optional).
* Place the input data file `(grades_data.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The mapper will emit the StudentID and their score.

```python
# mapper.py
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
```

## Write the Reducer Script
The reducer will calculate the total score for each student and assigns a grade.
```python
# reducer.py
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
```
## Prepare the Input Data
Create a file named <code>grades_data.txt</code> with sample input data:

```yaml
1,John,Math,85
1,John,Science,78
2,Jane,Math,92
2,Jane,Science,88
3,Tom,Math,55
3,Tom,Science,60
```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `MapReduceGrades/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts (optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/grades_data.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output
```yaml
2021	22
2022	27
```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreducegrade/input
hdfs dfs -put input/grades_data.txt /user/mapreducegrade/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreducegrade/input/grades_data.txt \
  -output /user/mapreducegrade/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreducegrade/output/part-00000
```

This will display

```css
1	81	B
2	90	A
3	57	F
```

## Explanation of Steps:

**Mapper:**

  Extracts the year and temperature and emits them as key-value pairs (year \t temperature).

**Reducer:**

  Groups data by year and calculates the maximum temperature for each year.
  
**Hadoop Streaming:**
  
  Allows you to use any language (like Python) to implement the mapper and reducer, instead of writing Java programs.

This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
