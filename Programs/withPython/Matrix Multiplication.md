# Develop a MapReduce program to implement Matrix Multiplication.

Matrix multiplication can be implemented using the MapReduce programming model. Here's how you can develop a MapReduce program for multiplying two matrices.

# Problem Statement

Given two matrices:

```bash
**A** of size M×N  
**B** of size N×P  

The resulting matrix **C** will be of size M×P, where:  

**C[i][j] = ∑(k=0 to N-1) A[i][k] * B[k][j]**
```

## Input Format

The input should contain both matrices in a single file, where each line specifies an element of one of the matrices. Use the following format:

```bash
MatrixName, RowIndex, ColumnIndex, Value
```

## Example

```math
Given matrices:

\[ A = \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix} \]  
\[ B = \begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} \]

The resulting matrix \( C \) is:

\[ C = \begin{bmatrix} 19 & 22 \\ 43 & 50 \end{bmatrix} \]
```


## Prepare Folder Structure

```graphql
mapreducematrixs/
├── input/
│   └── matrix_data.txt   # Input data file
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
* Place the input data file `(matrix_data.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The mapper generates intermediate key-value pairs for the multiplication.

```python
# mapper.py
import sys

for line in sys.stdin:
    line = line.strip()
    matrix, row, col, value = line.split(',')

    row = int(row)
    col = int(col)
    value = float(value)

    if matrix == 'A':
        # Emit all (i, k) for A[i][j]
        for k in range(2):  # Replace '2' with the number of columns in B
            print(f"{row},{k}\tA,{col},{value}")
    elif matrix == 'B':
        # Emit all (i, k) for B[j][k]
        for i in range(2):  # Replace '2' with the number of rows in A
            print(f"{i},{col}\tB,{row},{value}")

```

## Write the Reducer Script
The reducer computes the partial products and sums them up to calculate C[i][j]

```python
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

```
## Prepare the Input Data
Create a file named <code>matrix_data.txt</code> with sample input data:

```yaml
A,0,0,1
A,0,1,2
A,1,0,3
A,1,1,4
B,0,0,5
B,0,1,6
B,1,0,7
B,1,1,8
```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `mapreducematrixs/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts (optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/matrix_data.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output
```yaml
0,0	19.0
0,1	22.0
1,0	43.0
1,1	50.0
```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreducematrix/input
hdfs dfs -put input/matrix_data.txt /user/mapreducematrix/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreducematrix/input/matrix_data.txt \
  -output /user/mapreducematrix/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreducematrix/output/part-00000
```

This will display

```css
0,0	19.0
0,1	22.0
1,0	43.0
1,1	50.0
```

## Explanation of Steps:

**Mapper:**

  Emits the StudentID and their score as key value pair. 

**Reducer:**

  Calculate the total score for each student and assigns a grade.
  
**Hadoop Streaming:**
  
  Allows you to use any language (like Python) to implement the mapper and reducer, instead of writing Java programs.

This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
