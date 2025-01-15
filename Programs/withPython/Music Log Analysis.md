# XYZ.com is an online music website where users listen to various tracks, the data gets collected which is given below. 

The data is coming in log files and looks like as shown below

```sql
UserId | TrackId | Shared | Radio | Skip
111115 | 222 | 0 | 1 | 0
111113 | 225 | 1 | 0 | 0
111117 | 223 | 0 | 1 | 1
111115 | 225 | 1 | 0 | 0
```

## Write a MapReduce program to get the following
* Number of unique listeners
* Number of times the track was shared with others
* Number of times the track was listened to on the radio
* Number of times the track was listened to in total
* Number of times the track was skipped on the radio

## Input Format

The input data `(music_log.txt)` should be in the format:

```bash
userId,TrackId,Shared,Radio,Skip
```

## Prepare the Input Data
Create a file named <code>music_log.txt</code> with sample input data:

```yaml

UserId | TrackId | Shared | Radio | Skip
111115 | 222 | 0 | 1 | 0
111113 | 225 | 1 | 0 | 0
111117 | 223 | 0 | 1 | 1
111115 | 225 | 1 | 0 | 0


```

## Prepare Folder Structure

```graphql
MapReduceMusic/
├── input/
│   └── music_log.txt   # Input data file
├── scripts/
│   ├── mapper.py              # Mapper script
│   ├── reducer.py             # Reducer script
├── output/                    # (Optional) Local output folder for testing
```

## Steps to Set Up in VS Code

### Create the Project Folder:

* Open VS Code.
* Create a new folder named MapReduceMusic or any name you prefer.
* Open this folder in VS Code (File > Open Folder).

### Organize the Files:

* Inside the project folder, create the subdirectories input, scripts, and output (optional).
* Place the input data file `(music_log.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The mapper will emit key-value pairs for TrackId and relevant metrics.

```python

# mapper.py
import sys

for line in sys.stdin:
    # Skip the header if present
    if line.startswith("UserId"):
        continue
    
    # Split the line into fields
    fields = line.strip().split('|')
    if len(fields) == 5:
        user_id, track_id, shared, radio, skip = fields

        # Emit key-value pairs for each metric
        print(f"{track_id}\tuser\t{user_id}")    # For unique listeners
        print(f"{track_id}\tshared\t{shared}")  # Shared count
        print(f"{track_id}\tradio\t{radio}")    # Radio count
        print(f"{track_id}\ttotal\t1")         # Total listens
        print(f"{track_id}\tskip_radio\t{int(radio) * int(skip)}")  # Skip on radio

```

## Write the Reducer Script
The reducer will aggregate the metrics for each TrackId.

```python

# reducer.py
import sys
from collections import defaultdict

# Initialize trackers
track_listeners = defaultdict(set)
track_metrics = defaultdict(lambda: {"shared": 0, "radio": 0, "total": 0, "skip_radio": 0})

for line in sys.stdin:
    # Parse the input
    track_id, metric, value = line.strip().split('\t')

    if metric == "user":
        # Track unique listeners
        track_listeners[track_id].add(value)
    else:
        # Aggregate metrics
        track_metrics[track_id][metric] += int(value)

# Output the aggregated results
for track_id, metrics in track_metrics.items():
    unique_listeners = len(track_listeners[track_id])
    print(f"{track_id}\tUnique Listeners: {unique_listeners}, Shared: {metrics['shared']}, "
          f"Radio: {metrics['radio']}, Total: {metrics['total']}, Skip on Radio: {metrics['skip_radio']}")

```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `mapreducemusiclogss/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts (optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/music_log.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output

```yaml

222	Unique Listeners: 1, Shared: 0, Radio: 1, Total: 1, Skip on Radio: 0
223	Unique Listeners: 1, Shared: 0, Radio: 1, Total: 1, Skip on Radio: 1
225	Unique Listeners: 2, Shared: 2, Radio: 0, Total: 2, Skip on Radio: 0


```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreducemusiclogs/input
hdfs dfs -put input/music_log.txt /user/mapreducemusiclogs/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreducemusiclogs/input/music_log.txt \
  -output /user/mapreducemusiclogs/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreducemusiclogs/output/part-00000
```

This will display

```yaml

222	Unique Listeners: 1, Shared: 0, Radio: 1, Total: 1, Skip on Radio: 0
223	Unique Listeners: 1, Shared: 0, Radio: 1, Total: 1, Skip on Radio: 1
225	Unique Listeners: 2, Shared: 2, Radio: 0, Total: 2, Skip on Radio: 0

```

## Explanation of Steps:

**Mapper:**

  1. Parses the log data.

  2. Emits TrackId as the key, and appropriate values for:

    * Unique listeners: Tracks each user listening to the track.
    * Shared: Tracks how many times the track was shared.
    * Radio: Tracks how many times the track was listened to on the radio.
    * Total: Tracks the total listens.
    * Skip on radio: Tracks skips occurring during radio play.

**Reducer:**

1. Aggregates the values for each metric using:

    * Set for unique listeners.
    * Counters for other metrics.

2. Outputs a summary for each TrackId.

This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
