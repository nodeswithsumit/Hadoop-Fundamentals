# Develop a MapReduce program to find the maximum temperature in each year using Python.

Using Python, we can implement the same logic for finding the maximum temperature per year using the Hadoop Streaming API for MapReduce. Below is how you can approach this problem with a Python MapReduce program.

## Write the Mapper Script
The mapper will read the input line by line, extract the year and temperature, and output them in the format year \t temperature.

```python
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
```

## Write the Reducer Script
The reducer will read the mapper's output (sorted by key), find the maximum temperature for each year, and output the result.

```python
# reducer.py
import sys

current_year = None
max_temperature = None

for line in sys.stdin:
    # Remove leading and trailing whitespace
    line = line.strip()

    # Parse the input from the mapper
    year, temperature = line.split('\t', 1)
    temperature = int(temperature)

    # If we're processing a new year
    if current_year != year:
        if current_year is not None:
            # Output the max temperature for the previous year
            print(f"{current_year}\t{max_temperature}")
        # Reset variables for the new year
        current_year = year
        max_temperature = temperature
    else:
        # Update the max temperature for the current year
        max_temperature = max(max_temperature, temperature)

# Output the max temperature for the last year
if current_year is not None:
    print(f"{current_year}\t{max_temperature}")
```
## Prepare the Input Data
Create a file named <code>temperature_data.txt</code> with sample input data:

```yaml
2021,01,01,22
2021,01,02,21
2022,01,01,25
2022,01,02,27
```

## Test Locally
Test the program locally using standard input and output:

```bash
cat temperature_data.txt | python mapper.py | sort | python reducer.py
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
hdfs dfs -mkdir /user/hadoop/input
hdfs dfs -put temperature_data.txt /user/hadoop/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/hadoop/input/temperature_data.txt \
  -output /user/hadoop/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/hadoop/output/part-00000
```

This will display

```yaml
This will display:
```

## Explanation of Steps:

**Mapper:**

  Extracts the year and temperature and emits them as key-value pairs (year \t temperature).

**Reducer:**

  Groups data by year and calculates the maximum temperature for each year.
  
**Hadoop Streaming:**
  
  Allows you to use any language (like Python) to implement the mapper and reducer, instead of writing Java programs.

This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
