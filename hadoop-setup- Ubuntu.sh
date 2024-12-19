## KINDLY FOLLOW THIS FOR UBUNTU SETUP

# Update the system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install Java (Hadoop requires Java)
sudo apt install default-jdk -y
java -version

# Create a hadoop user and set up SSH
sudo adduser hadoop
sudo usermod -aG sudo hadoop
su - hadoop

# Generate SSH key for hadoop user
ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 640 ~/.ssh/authorized_keys

# Download and extract Hadoop (using version 3.3.6 as an example)
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzf hadoop-3.3.6.tar.gz
mv hadoop-3.3.6 hadoop

# Set up environment variables
echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> ~/.bashrc
echo 'export HADOOP_HOME=/home/hadoop/hadoop' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> ~/.bashrc
source ~/.bashrc

# Configure Hadoop files
# 1. core-site.xml
cat > $HADOOP_HOME/etc/hadoop/core-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOL

# 2. hdfs-site.xml
cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/home/hadoop/data/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/home/hadoop/data/datanode</value>
    </property>
</configuration>
EOL

# 3. mapred-site.xml
cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOL

# 4. yarn-site.xml
cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
</configuration>
EOL

# Create directories for namenode and datanode
mkdir -p /home/hadoop/data/namenode
mkdir -p /home/hadoop/data/datanode

# Set proper permissions
sudo chown -R hadoop:hadoop /home/hadoop/data

# Format the namenode
hdfs namenode -format

# Start Hadoop services
start-dfs.sh
start-yarn.sh

# Verify the services are running
jps

# Create basic HDFS directories
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hadoop
hdfs dfs -chmod g+w /user/hadoop
