# Running MapReduce Jobs

1. Prepare Input Data Upload input data to HDFS:

  ```bash
  hdfs dfs -mkdir /wordcount/input
  hdfs dfs -put input.txt /wordcount/input/
  ```

2. Run a Built-in WordCount Example Hadoop comes with example JARs:
 
 ```bash
 hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /wordcount/input /wordcount/output
 ```

3. Check the Output View the result:

 ```bash
 hdfs dfs -cat /wordcount/output/part-r-00000
 ```
