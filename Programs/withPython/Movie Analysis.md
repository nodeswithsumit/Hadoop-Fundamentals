# Develop a MapReduce program to find the tags associated with each movie by analyzing movie lens data.

Using Python, we can implement the same logic for analyzing MovieLens dataset and finding tags associated with each movie using the Hadoop Streaming API for MapReduce. Below is how you can approach this problem with a Python MapReduce program.

## Input Format

The input data `(tags_data.txt)` should be in the format:

```bash
userId,movieId,tag,timestamp
```

## Prepare the Input Data
Create a file named <code>tags_data.txt</code> with sample input data:

```yaml
userId,movieId,tag,timestamp
1,2,funny,1437066629
2,2,romantic,1437066653
3,1,drama,1437066667
4,3,thriller,1437066679
1,1,classic,1437066693

```

## Prepare Folder Structure

```graphql
MapReduceMovie/
├── input/
│   └── tags_data.txt   # Input data file
├── scripts/
│   ├── mapper.py              # Mapper script
│   ├── reducer.py             # Reducer script
├── output/                    # (Optional) Local output folder for testing
```

## Steps to Set Up in VS Code

### Create the Project Folder:

* Open VS Code.
* Create a new folder named MapReduceMovie or any name you prefer.
* Open this folder in VS Code (File > Open Folder).

### Organize the Files:

* Inside the project folder, create the subdirectories input, scripts, and output (optional).
* Place the input data file `(weather_data.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The mapper will emit the `movieId` and the tag for each movie.

```python

# mapper.py
import sys

# Read input from stdin
for line in sys.stdin:
    # Skip header
    if line.startswith("userId"):
        continue

    # Strip leading/trailing whitespace and split the line into fields
    fields = line.strip().split(',')
    
    # Extract movieId and tag
    if len(fields) >= 3:
        movie_id = fields[1]
        tag = fields[2]
        
        # Emit movieId and tag
        print(f"{movie_id}\t{tag}")

```

## Write the Reducer Script
The reducer will group tags by `movieId` and output a list of tags associated with each movie.

```python

# reducer.py
import sys
from collections import defaultdict

# Dictionary to hold tags for each movieId
movie_tags = defaultdict(list)

# Read input from stdin
for line in sys.stdin:
    # Split the input line into movieId and tag
    movie_id, tag = line.strip().split('\t')
    
    # Add the tag to the list of tags for this movieId
    movie_tags[movie_id].append(tag)

# Output the movieId and associated tags
for movie_id, tags in movie_tags.items():
    # Join tags with commas
    tags_list = ','.join(tags)
    print(f"{movie_id}\t{tags_list}")


```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `mapreducemovies/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts (optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/tags_data.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output

```yaml

1	drama,classic
2	funny,romantic
3	thriller

```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreducemovie/input
hdfs dfs -put input/tags_data.txt /user/mapreducemovie/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreducemovie/input/tags_data.txt \
  -output /user/mapreducemovie/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreducemovie/output/part-00000
```

This will display

```yaml
1	drama,classic
2	funny,romantic
3	thriller
```


## Explanation of Steps:

**Mapper:**

  * Reads each record from the `tags_data.csv` file.

  * Extracts the `movieId` and the `tag` for each movie and emits them as key-value pairs:

    * Key: `movieId`

    * Value: `tag`

**Reducer:**

  * Aggregates all tags associated with each movieId.
  
  * Outputs the movieId and the associated tags as a comma-separated list.
  
**Hadoop Streaming:**
  
  * Hadoop Streaming allows you to use any language (like Python) to implement the mapper and reducer, instead of writing Java programs.


This Python-based approach simplifies the development process while leveraging Hadoop's distributed processing capabilities!
