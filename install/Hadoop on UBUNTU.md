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

   # Set JAVA_HOME
   export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
   #Add JAVA_HOME/bin to the PATH
   export PATH=$JAVA_HOME/bin:$PATH
   
   export HADOOP_HOME=/home/user-1/hadoop-3.4.0/   #replace the hadoop version as per your version and the location as well if needed.
   export HADOOP_INSTALL=$HADOOP_HOME
   export HADOOP_MAPRED_HOME=$HADOOP_HOME
   export HADOOP_COMMON_HOME=$HADOOP_HOME
   export HADOOP_HDFS_HOME=$HADOOP_HOME
   export HADOOP_YARN_HOME=$HADOOP_HOME
   export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
   export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
   export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/nativ"
   export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
   ```
   Apply changes:
   ```bash
   source ~/.bashrc
   ```


   **key generation**
   ```bash
   ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
   ```
   ```bash
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   ```

   ```bash
   chmod 0600 ~/.ssh/id_rsa.pub
   ```
   ```bash
   ssh localhost
   ```
   
3. **Configure core-site.xml:**
   Edit the `core-site.xml` file:
   ```bash
   nano $HADOOP_HOME/etc/hadoop/core-site.xml
   ```
   Add:
   ```xml
   <configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/user-1/hdfs/tmp/</value>   # replace `/home/user-1` with the location you have if required.
    </property>
    <property>
        <name>fs.default.name</name>
        <value>hdfs://127.0.0.1:9000</value>
    </property>
   </configuration>
   ```

4. **Configure hdfs-site.xml:**
   ```bash
   nano $HADOOP_HOME/etc/hadoop/hdfs-site.xml
   ```
   Add:
   ```xml
   <configuration>
     <property>
         <name>dfs.data.dir</name>
         <value>/home/user-1/hdfs/namenode</value>      # replace `/home/user-1` with the location you have if required.
     </property>
     <property>
         <name>dfs.data.dir</name>
         <value>/home/user-1/hdfs/datanode</value>      # replace `/home/user-1` with the location you have if required.
     </property>
     <property>
         <name>dfs.replication</name>
         <value>1</value>
     </property>
   </configuration>
   ```


5. **Configure mapred-site.xml:**
   Edit the `mapred-site.xml` file:
   ```bash
   nano $HADOOP_HOME/etc/hadoop/mapred-site.xml
   ```
   Add:
   ```xml
   <configuration> 
     <property> 
       <name>mapreduce.framework.name</name> 
       <value>yarn</value> 
     </property> 
   </configuration>
   ```

6. **Configure yarn-site.xml:**
   Edit the `yarn-site.xml` file:
   ```bash
   nano $HADOOP_HOME/etc/hadoop/yarn-site.xml
   ```
   Add:
   ```xml
   <configuration>
     <property>
       <name>yarn.nodemanager.aux-services</name>
       <value>mapreduce_shuffle</value>
     </property>
     <property>
       <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
       <value>org.apache.hadoop.mapred.ShuffleHandler</value>
     </property>
     <property>
       <name>yarn.resourcemanager.hostname</name>
       <value>127.0.0.1</value>
     </property>
     <property>
       <name>yarn.acl.enable</name>
       <value>0</value>
     </property>
     <property>
       <name>yarn.nodemanager.env-whitelist</name>   
       <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
     </property>
   </configuration>
   ```

**5. Format the NameNode**

Run the following command to format the NameNode:
```bash
hdfs namenode -format
```

---

**6. Start Hadoop Services**

You can diractly run all to check instead of doing it individually but if needed, you can can follow it individual wise as well.

```bash
start-all.sh      # remember to stop you will write stop-all.sh
```

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
**Conclusion**

You have successfully set up Hadoop on Ubuntu. You can now start leveraging Hadoop’s capabilities for big data storage and processing.

---

