**Title: Setting Up Hadoop on Ubuntu**

---

**Introduction**

Hadoop is an open-source framework for distributed storage and processing of big data. This guide walks you through the steps to set up Hadoop on an Ubuntu system.

---

**1. Prerequisites**

- An Ubuntu machine (preferably 20.04 or later).
- At least 4GB of RAM.
- Java installed (Hadoop requires Java).
- Root or sudo access to the system.

---

**2. Install Java**

1. **Check if Java is installed:**
   ```bash
   java -version
   ```

2. **Install Java if not installed:**
   ```bash
   sudo apt update
   sudo apt install openjdk-11-jdk -y
   ```

3. **Verify Java installation:**
   ```bash
   java -version
   ```

---

**3. Download and Install Hadoop**

1. **Create a Hadoop user:**
   ```bash
   sudo adduser hadoop
   sudo usermod -aG sudo hadoop
   ```

2. **Switch to the Hadoop user:**
   ```bash
   su - hadoop
   ```

3. **Download Hadoop:**
   Visit the [Apache Hadoop website](https://hadoop.apache.org/) and copy the download link for the latest stable release. Then, run:
   ```bash
   wget https://downloads.apache.org/hadoop/common/hadoop-x.y.z/hadoop-x.y.z.tar.gz
   ```

   Replace `x.y.z` with the version number.

4. **Extract the downloaded file:**
   ```bash
   tar -xzvf hadoop-x.y.z.tar.gz
   ```

5. **Move Hadoop to /usr/local/hadoop:**
   ```bash
   sudo mv hadoop-x.y.z /usr/local/hadoop
   ```

---

**4. Configure Hadoop**

1. **Edit environment variables:**
   Open the `.bashrc` file and add the following lines:
   ```bash
   export HADOOP_HOME=/usr/local/hadoop
   export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
   export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
   ```
   Apply changes:
   ```bash
   source ~/.bashrc
   ```

2. **Configure core-site.xml:**
   Edit the `core-site.xml` file:
   ```bash
   nano $HADOOP_HOME/etc/hadoop/core-site.xml
   ```
   Add:
   ```xml
   <configuration>
       <property>
           <name>fs.defaultFS</name>
           <value>hdfs://localhost:9000</value>
       </property>
   </configuration>
   ```

3. **Configure hdfs-site.xml:**
   ```bash
   nano $HADOOP_HOME/etc/hadoop/hdfs-site.xml
   ```
   Add:
   ```xml
   <configuration>
       <property>
           <name>dfs.replication</name>
           <value>1</value>
       </property>
       <property>
           <name>dfs.namenode.name.dir</name>
           <value>file:///usr/local/hadoop/data/namenode</value>
       </property>
       <property>
           <name>dfs.datanode.data.dir</name>
           <value>file:///usr/local/hadoop/data/datanode</value>
       </property>
   </configuration>
   ```

4. **Create directories for NameNode and DataNode:**
   ```bash
   sudo mkdir -p /usr/local/hadoop/data/namenode
   sudo mkdir -p /usr/local/hadoop/data/datanode
   sudo chown -R hadoop:hadoop /usr/local/hadoop/data
   ```

---

**5. Format the NameNode**

Run the following command to format the NameNode:
```bash
hdfs namenode -format
```

---

**6. Start Hadoop Services**

1. **Start NameNode and DataNode:**
   ```bash
   start-dfs.sh
   ```

2. **Start YARN services:**
   ```bash
   start-yarn.sh
   ```

3. **Verify services:**
   Open your browser and navigate to:
   - HDFS: `http://localhost:9870`
   - YARN: `http://localhost:8088`

---

**7. Running a Test Job**

1. **Create a directory in HDFS:**
   ```bash
   hdfs dfs -mkdir /test
   ```

2. **List directories in HDFS:**
   ```bash
   hdfs dfs -ls /
   ```

3. **Upload a file to HDFS:**
   ```bash
   hdfs dfs -put /path/to/local/file /test
   ```

4. **List files in HDFS directory:**
   ```bash
   hdfs dfs -ls /test
   ```

---

**Conclusion**

You have successfully set up Hadoop on Ubuntu. You can now start leveraging Hadoop’s capabilities for big data storage and processing.

---

