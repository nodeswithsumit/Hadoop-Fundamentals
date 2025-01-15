# Develop a MapReduce to find the maximum electrical consumption in each year given electrical consumption for each month in each year.

To apprach this problem we can proceed as follows:

## Input Format

The input data `(electricity_data.txt)` should be in the format:

```bash
Year,Month,Consumption
```

## Prepare the Input Data
Create a file named <code>electricity_data.txt</code> with sample input data:

```yaml
2020,01,300
2020,02,350
2020,03,400
2020,04,250
2021,01,500
2021,02,450
2021,03,480
2021,04,470
```

## Prepare Folder Structure

```graphql
MapReduceElect/
├── input/
│   └── electricity_data.txt   # Input data file
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
* Place the input data file `(electricity_data.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The mapper will process each line of input and emit the year as the key and the consumption as the value.

```python

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

```

## Write the Reducer Script
The reducer will receive all records grouped by the year and calculate the maximum consumption for each year.

```python

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

```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `mapreduceelects/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts (optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/electricity_data.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output
```yaml
2020	400
2021	500
```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreduceelect/input
hdfs dfs -put input/electricity_data.txt /user/mapreduceelect/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreduceelect/input/electricity_data.txt \
  -output /user/mapreduceelect/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreduceelect/output/part-00000
```

This will display

```yaml
2020	400
2021	500
```

## Notes:

* Assumptions: The input data format is consistent with no missing values.
* Scaling: For larger datasets, ensure that the number of reducers is sufficient to distribute the workload effectively.
* Modifications: Update the script if additional processing (e.g., handling missing values) is needed.


## Explanation of Steps:

**Mapper:**

  Emits the Year and the Consumption as key-value pairs. This ensures that all monthly consumptions for a given year are grouped together during the shuffle and sort phase.

**Reducer:**

  Processes the grouped data for each year and calculates the maximum consumption. This represents the highest monthly electrical usage for that year.
  
**Hadoop Streaming:**
  
  Allows you to use any language (like Python) to implement the mapper and reducer, instead of writing Java programs.

This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
