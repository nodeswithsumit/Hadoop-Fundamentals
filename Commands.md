# Hadoop Essentials: Commands

## Setting up Hadoop
### Before diving into commands and programs, ensure Hadoop is installed and properly configured.

1. **Prerequisites**
    * Java: Install Java 8 or 11.
    * Hadoop: Download and extract the Hadoop binary distribution (preferably the latest stable version).

    ```bash
    java -version   # to check if java is installed 
    hadoop version  # to check if hadoop is installed
    ```
## HDFS Commands

2. **Basic File Operations**

    * **List files in HDFS:**
    ```bash
    hdfs dfs -ls /
    ```
    * **Create a directory in HDFS:**
    ```bash
    hdfs dfs -mkdir /user/data
    ```
