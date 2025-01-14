# Hadoop Essentials: Commands

## Setting up Hadoop

### Before diving into commands and programs, ensure Hadoop is installed and properly configured.

**1. Prerequisites**

  * **Java:** Install Java 8 or 11.

     * Verify installation:
          
       ```bash
        java -version 
       ```

  * **Hadoop:** Download and extract the Hadoop binary distribution (preferably the latest stable version).
        
    * Verify installation:
          
       ```bash
        hadoop version 
       ```

## HDFS Commands

### Basic File Operations

* **List files in HDFS:**

    ```bash
    hdfs dfs -ls / 
    ```

* **Create a directory in HDFS:**

    ```bash
    hdfs dfs -mkdir /user
    hdfs dfs -mkdir /user/data 
    ```

* **Upload a file to HDFS:**

    ```bash
    hdfs dfs -put localfile.txt /user/data/ 
    ```

* **Download a file from HDFS:**

    ```bash
    hdfs dfs -get /user/data/file.txt /local/path/ 
    ```

* **Delete a file from HDFS:**

    ```bash
    hdfs dfs -rm /user/data/file.txt 
    ```

* **Display the contents of a file in HDFS:**

    ```bash
    hdfs dfs -cat /user/data/file.txt 
    ```

### HDFS Health Check

* **Check HDFS status:**

    ```bash
    hdfs dfsadmin -report 
    ```

### File System Disk Usage

* **Check HDFS space usage:**

    ```bash
    hdfs dfs -du -h / 
    ```

## MapReduce Commands 

* **Submit a MapReduce job:**

    ```bash
    hadoop jar /path/to/your/jar/file.jar your.main.class 
    ```

* **Check job status:**

    ```bash
    hadoop job -list 
    ```

* **Track job progress:**

    ```bash
    hadoop job -status job_id 
    ```

* **Kill a running job:**

    ```bash
    hadoop job -kill job_id 
    ```

## YARN Commands

* **Check YARN resource usage:**

    ```bash
    yarn resourcemanager -listResources 
    ```

* **View NodeManager information:**

    ```bash
    yarn node -list 
    ```

* **Submit an application to YARN:**

    ```bash
    yarn jar /path/to/your/jar/file.jar your.main.class 
    ```

**Note:** These are basic commands. You can find more advanced options and usage examples in the official Hadoop documentation.

Thanks for taking time to go with this file. Enjoy Coding 
