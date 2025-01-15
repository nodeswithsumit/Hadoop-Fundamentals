# Develop a MapReduce program to find the maximum temperature in each year

**To develop a MapReduce program to find the maximum temperature in each year, we will implement a program that processes weather data, which could be in the format:**

```yaml
Year, Month, Day, Temperature
2021, 01, 01, 22
2021, 01, 02, 21
2022, 01, 01, 25
2022, 01, 02, 27
```

The objective is to find the maximum temperature for each year. Here's the MapReduce code in Java:

## Mapper Class
The mapper will read each line of the input data, extract the year and temperature, and emit the year as the key and the temperature as the value.

```java
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

public class MaxTemperatureMapper extends Mapper<Object, Text, Text, IntWritable> {

    private Text year = new Text();
    private IntWritable temperature = new IntWritable();

    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        String[] fields = value.toString().split(",");
        
        // Assuming data format is: Year, Month, Day, Temperature
        if (fields.length == 4) {
            try {
                year.set(fields[0].trim());  // Extract the year
                temperature.set(Integer.parseInt(fields[3].trim()));  // Extract the temperature
                context.write(year, temperature);  // Emit year and temperature as key-value pair
            } catch (NumberFormatException e) {
                // Skip invalid rows
            }
        }
    }
}
```


## Reducer Class
The reducer will receive the year as the key and a list of temperatures as the value. It will find the maximum temperature for each year.

```java
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class MaxTemperatureReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

    private IntWritable maxTemperature = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        int maxTemp = Integer.MIN_VALUE;
        
        // Iterate through the temperatures for the year
        for (IntWritable val : values) {
            maxTemp = Math.max(maxTemp, val.get());
        }
        
        maxTemperature.set(maxTemp);  // Set the maximum temperature
        context.write(key, maxTemperature);  // Emit the year and the maximum temperature
    }
}
```

## Driver Class
This class will configure the MapReduce job and execute the mapper and reducer.

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class MaxTemperature {

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: MaxTemperature <input path> <output path>");
            System.exit(-1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Max Temperature");
        
        job.setJarByClass(MaxTemperature.class);
        job.setMapperClass(MaxTemperatureMapper.class);
        job.setReducerClass(MaxTemperatureReducer.class);
        
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
```

## Explanation
  ### Mapper:

  * Reads the input data line by line.
  * Splits each line into fields using a comma as the delimiter.
  * Extracts the year and temperature.
  * Emits the year as the key and the temperature as the value.

  ## Reducer:

  * Receives the year and a list of temperatures.
  * Finds the maximum temperature by iterating through the list of temperatures for that year.
  * Outputs the year and the maximum temperature.

  ## Driver:

  * Configures and runs the MapReduce job with input and output paths.

## Running the Program
To run this program, you will need to package it into a .jar file and run it on your Hadoop cluster. The command to run the job would look like this:

```bash
hadoop jar MaxTemperature.jar MaxTemperature /input/data /output
```
This will process the data in <code>/input/data</code> and save the results in the <code>/output</code> directory.

