# Develop a MapReduce program to analyze a weather dataset and classify days as "shiny" or "cool".

## Problem Statement
Given a dataset containing weather details (temperature and sunshine hours), classify each day:

* A shiny day if the sunshine hours exceed a specific threshold (e.g., 8 hours).
* A cool day if the temperature is below a specific threshold (e.g., 15°C).


## Input Format

The input data `(weather_data.txt)` should be in the format:

```bash
Date,Temperature,SunshineHours
```

## Prepare the Input Data
Create a file named <code>weather_data.txt</code> with sample input data:

```yaml

2025-01-01,10,9
2025-01-02,12,5
2025-01-03,16,10
2025-01-04,14,7
2025-01-05,20,12
2025-01-06,13,6
2025-01-07,15,3
2025-01-08,19,8
2025-01-09,11,4
2025-01-10,17,9
2025-01-11,14,5
2025-01-12,10,10
2025-01-13,18,6
2025-01-14,20,11
2025-01-15,16,8
2025-01-16,15,7
2025-01-17,12,6
2025-01-18,10,9
2025-01-19,14,10
2025-01-20,18,11
2025-01-21,13,5
2025-01-22,19,12
2025-01-23,11,3
2025-01-24,15,6
2025-01-25,16,8
2025-01-26,17,10
2025-01-27,14,4
2025-01-28,13,7
2025-01-29,11,6
2025-01-30,12,8
2025-01-31,18,9

```

## Prepare Folder Structure

```graphql
MapReduceWeather/
├── input/
│   └── weather_data.txt   # Input data file
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
* Place the input data file `(weather_data.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The mapper will classify each day based on the temperature and sunshine hours and emit the classification as the key.

```python

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

```

## Write the Reducer Script
The reducer will group and count the number of shiny and cool days.

```python

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

```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `mapreduceweathers/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts (optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/weather_data.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output
```yaml
Cool	120
Shiny	245
```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreduceweather/input
hdfs dfs -put input/weather_data.txt /user/mapreduceweather/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreduceweather/input/weather_data.txt \
  -output /user/mapreduceweather/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreduceweather/output/part-00000
```

This will display

```yaml
Cool	120
Shiny	245
```


## Explanation of Steps:

**Mapper:**

  Reads the weather data and classifies each day as shiny (if sunshine hours exceed the threshold) or cool (if temperature is below the threshold).

**Reducer:**

  Groups and counts the number of shiny and cool days, providing a summary of the classification.
  
**Hadoop Streaming:**
  
  Allows the use of Python to implement the mapper and reducer, simplifying the process of analyzing weather data while leveraging Hadoop's distributed processing capabilities.

This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
