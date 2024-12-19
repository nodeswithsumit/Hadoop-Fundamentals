# Setting Up Hadoop on an AWS EC2 Linux Machine

This guide provides a step-by-step process to set up Hadoop on an AWS EC2 Linux instance. Hadoop is an open-source framework used for distributed storage and processing of large datasets.

## Prerequisites

1. **AWS Account:** Create an AWS account if you don’t already have one.
2. **SSH Client:** Install an SSH client (e.g., OpenSSH, PuTTY) on your local machine.
3. **Java:** Hadoop requires Java. Ensure that the required version of Java is installed on the EC2 instance.

---

## Step 1: Launch an EC2 Instance

1. **Log in to AWS Management Console** and navigate to the EC2 Dashboard.
2. **Create an EC2 instance:**
   - Choose the "Amazon Linux 2" or "Ubuntu" AMI.
   - Select an instance type (e.g., t2.micro for free-tier eligibility).
   - Configure instance details and security groups.
   - Open the necessary ports (e.g., SSH - port 22).
3. Download the private key file (“.pem”) for your instance.

---

## Step 2: Connect to the EC2 Instance

1. Open your terminal and navigate to the directory where the private key file is stored.
2. Run the following command to connect via SSH:
   ```bash
   ssh -i your-key.pem ec2-user@your-instance-public-ip
   ```
   Replace `your-key.pem` and `your-instance-public-ip` with your key and instance details.

---

## Step 3: Install Java

1. Update the package index:
   ```bash
   sudo yum update -y
   ```
   (For Ubuntu, use `sudo apt update`.)
2. Install Java:
   ```bash
   sudo yum install -y java-1.8.0-openjdk
   ```
   Verify installation:
   ```bash
   java -version
   ```

---

## Step 4: Download and Configure Hadoop

1. **Download Hadoop:**
   ```bash
   wget https://downloads.apache.org/hadoop/common/stable/hadoop-3.x.x.tar.gz
   ```
   Replace `3.x.x` with the latest version number.
2. Extract the archive:
   ```bash
   tar -xzvf hadoop-3.x.x.tar.gz
   ```
   Move the extracted files to `/usr/local/`:
   ```bash
   sudo mv hadoop-3.x.x /usr/local/hadoop
   ```
3. **Configure Hadoop Environment Variables:**
   Edit the `.bashrc` file:
   ```bash
   nano ~/.bashrc
   ```
   Add the following lines:
   ```bash
   export HADOOP_HOME=/usr/local/hadoop
   export PATH=$PATH:$HADOOP_HOME/bin
   ```
   Save and reload the configuration:
   ```bash
   source ~/.bashrc
   ```

---

## Step 5: Configure Hadoop Files

1. Navigate to the `hadoop/etc/hadoop` directory:
   ```bash
   cd /usr/local/hadoop/etc/hadoop
   ```
2. Edit `core-site.xml`:
   ```bash
   nano core-site.xml
   ```
   Add the following configuration:
   ```xml
   <configuration>
     <property>
       <name>fs.defaultFS</name>
       <value>hdfs://localhost:9000</value>
     </property>
   </configuration>
   ```
3. Edit `hdfs-site.xml`:
   ```bash
   nano hdfs-site.xml
   ```
   Add the following:
   ```xml
   <configuration>
     <property>
       <name>dfs.replication</name>
       <value>1</value>
     </property>
   </configuration>
   ```
4. Edit `mapred-site.xml`:
   ```bash
   cp mapred-site.xml.template mapred-site.xml
   nano mapred-site.xml
   ```
   Add the following:
   ```xml
   <configuration>
     <property>
       <name>mapreduce.framework.name</name>
       <value>yarn</value>
     </property>
   </configuration>
   ```
5. Edit `yarn-site.xml`:
   ```bash
   nano yarn-site.xml
   ```
   Add:
   ```xml
   <configuration>
     <property>
       <name>yarn.nodemanager.aux-services</name>
       <value>mapreduce_shuffle</value>
     </property>
   </configuration>
   ```

---

## Step 6: Format Hadoop Namenode

1. Format the namenode:
   ```bash
   hdfs namenode -format
   ```
2. Start Hadoop services:
   ```bash
   start-dfs.sh
   start-yarn.sh
   ```
3. Verify that the services are running:
   ```bash
   jps
   ```

---

## Step 7: Test Hadoop

1. Create an HDFS directory:
   ```bash
   hdfs dfs -mkdir /test
   ```
2. Verify the directory:
   ```bash
   hdfs dfs -ls /
   ```
3. Upload a test file:
   ```bash
   echo "Hello Hadoop" > testfile.txt
   hdfs dfs -put testfile.txt /test
   ```
4. List the uploaded file:
   ```bash
   hdfs dfs -ls /test
   ```

---

## Conclusion

Your Hadoop setup on an AWS EC2 instance is now complete. You can further configure and scale your Hadoop cluster based on your requirements.

