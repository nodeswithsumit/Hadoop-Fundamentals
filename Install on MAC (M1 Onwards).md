**Setting Up Hadoop on macOS with M1 Chip**

Hadoop is a powerful framework for distributed storage and processing of big data. Setting it up on a macOS system with an M1 chip requires some adjustments due to the architecture differences. This document provides a step-by-step guide to successfully configure Hadoop on an M1 Mac.

---

### Prerequisites

1. **macOS Terminal**
2. **Java JDK** (at least version 8)
3. **Homebrew**

Ensure that your system is up-to-date by running:

```bash
sudo softwareupdate -i -a
```

---

### Step 1: Install Homebrew

Homebrew simplifies package management on macOS. If not already installed, execute the following in the Terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Update Homebrew:

```bash
brew update
```

---

### Step 2: Install Java

Hadoop requires Java. To install OpenJDK:

```bash
brew install openjdk@11
```

Set up Java environment variables:

1. Find the Java installation path:

   ```bash
   /usr/libexec/java_home -v 11
   ```

2. Add the following to your `~/.zshrc` file:

   ```bash
   export JAVA_HOME=$(/usr/libexec/java_home -v 11)
   export PATH=$JAVA_HOME/bin:$PATH
   ```

3. Reload the configuration:

   ```bash
   source ~/.zshrc
   ```

Verify the installation:

```bash
java -version
```

---

### Step 3: Install Hadoop

1. Use Homebrew to install Hadoop:

   ```bash
   brew install hadoop
   ```

2. Check the Hadoop installation:

   ```bash
   hadoop version
   ```

---

### Step 4: Configure Hadoop

1. **Modify Hadoop Environment Variables:**

   Add the following lines to your `~/.zshrc` file:

   ```bash
   export HADOOP_HOME=$(brew --prefix hadoop)
   export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
   ```

   Reload the configuration:

   ```bash
   source ~/.zshrc
   ```

2. **Update Configuration Files:**

   Navigate to the Hadoop configuration directory:

   ```bash
   cd $(brew --prefix hadoop)/etc/hadoop
   ```

   Edit the following files:

   **core-site.xml:**
   
   ```xml
   <configuration>
       <property>
           <name>fs.defaultFS</name>
           <value>hdfs://localhost:9000</value>
       </property>
   </configuration>
   ```

   **hdfs-site.xml:**
   
   ```xml
   <configuration>
       <property>
           <name>dfs.replication</name>
           <value>1</value>
       </property>
   </configuration>
   ```

   **mapred-site.xml.template:** Rename this file to `mapred-site.xml` and add the following:

   ```xml
   <configuration>
       <property>
           <name>mapreduce.framework.name</name>
           <value>yarn</value>
       </property>
   </configuration>
   ```

   **yarn-site.xml:**

   ```xml
   <configuration>
       <property>
           <name>yarn.nodemanager.aux-services</name>
           <value>mapreduce_shuffle</value>
       </property>
   </configuration>
   ```

---

### Step 5: Format the Hadoop Filesystem

Before starting Hadoop, format the filesystem:

```bash
hdfs namenode -format
```

---

### Step 6: Start Hadoop Services

Start the Hadoop daemons:

```bash
start-dfs.sh
start-yarn.sh
```

Verify that the services are running:

```bash
jps
```

You should see processes like `NameNode`, `DataNode`, `ResourceManager`, and `NodeManager` listed.

---

### Step 7: Access Hadoop

Hadoop provides web-based GUIs for monitoring:

- **NameNode Web UI:** `http://localhost:9870`
- **ResourceManager Web UI:** `http://localhost:8088`

---

### Step 8: Test Hadoop Setup

1. Create a directory in HDFS:

   ```bash
   hdfs dfs -mkdir /user
   hdfs dfs -mkdir /user/<your_username>
   ```

2. Copy a file to HDFS:

   ```bash
   hdfs dfs -put /path/to/local/file /user/<your_username>/
   ```

3. List files in HDFS:

   ```bash
   hdfs dfs -ls /user/<your_username>/
   ```

4. Retrieve the file from HDFS:

   ```bash
   hdfs dfs -get /user/<your_username>/file /local/path
   ```

---

### Troubleshooting

1. **Environment Variables:** Ensure all environment variables are correctly set in `~/.zshrc`.
2. **Java Compatibility:** Hadoop works best with Java 8 or 11.
3. **Daemon Errors:** Check log files in the Hadoop `logs` directory for detailed error messages.

---

### Conclusion

This guide outlines the steps to set up Hadoop on a macOS system with an M1 chip. With proper configuration, you can utilize Hadoop for big data processing tasks efficiently.

