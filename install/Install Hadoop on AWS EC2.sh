<h1>HADOOP INSTALLATION - EC2 (LINUX)</h1>

# Update the system packages using yum (Amazon Linux package manager)
sudo yum update -y

# Install Java OpenJDK 17 (Amazon Linux compatible version)
sudo yum install java-17-amazon-corretto-devel -y
java -version 

# Create hadoop user and set up permissions
sudo useradd hadoop
sudo passwd hadoop  # You'll be prompted to set a password
sudo usermod -aG wheel hadoop  # Adds hadoop user to sudoers group
su - hadoop

# Set up SSH for the hadoop user
ssh-keygen -t rsa -P ""  # I have given authorized_keys as my folder name

The SSH keys should be in the .ssh directory, but they were created in your home directory instead. Kindly fix this as given below:
First, let's create the .ssh directory with the right permissions:
mkdir -p ~/.ssh
chmod 700 ~/.ssh
Now, let's move the existing keys to the correct location and set proper permissions:
mv ~/authorized_keys ~/.ssh/id_rsa
mv ~/authorized_keys.pub ~/.ssh/id_rsa.pub
Next, we need to create the authorized_keys file correctly:
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

After running these commands, you can verify the setup is correct:
ls -la ~/.ssh
You should see something like this:

drwx------  2 hadoop hadoop  .ssh
-rw-------  1 hadoop hadoop  id_rsa
-rw-r--r--  1 hadoop hadoop  id_rsa.pub
-rw-------  1 hadoop hadoop  authorized_keys



# Download and extract Hadoop (using version 3.3.6)
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzf hadoop-3.3.6.tar.gz
mv hadoop-3.3.6 hadoop

# Set up environment variables in .bash_profile (Amazon Linux uses .bash_profile by default)
echo '# Hadoop Environment Variables' >> ~/.bash_profile
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> ~/.bash_profile
echo 'export HADOOP_HOME=/home/hadoop/hadoop' >> ~/.bash_profile
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bash_profile
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bash_profile
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bash_profile
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bash_profile
echo 'export YARN_HOME=$HADOOP_HOME' >> ~/.bash_profile
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bash_profile
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"' >> ~/.bash_profile
source ~/.bash_profile

# Configure hadoop-env.sh to use correct Java path
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Configure core-site.xml
cat > $HADOOP_HOME/etc/hadoop/core-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/hadoop/data/tmp</value>
    </property>
</configuration>
EOL

# Configure hdfs-site.xml
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

# Configure mapred-site.xml
cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOL

# Configure yarn-site.xml
cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml << 'EOL'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
EOL

# Create necessary directories
mkdir -p /home/hadoop/data/namenode
mkdir -p /home/hadoop/data/datanode
mkdir -p /home/hadoop/data/tmp

# Set proper permissions
sudo chown -R hadoop:hadoop /home/hadoop/data

# Format the HDFS namenode (only do this once)
hdfs namenode -format


# After doing this you might get an erroe like given below

[sudo] password for hadoop: 
[hadoop@ip-172-31-9-7 ~]$ hdfs namenode -format
ERROR: JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk does not exist.

# this is happening because we installed Java 17 (Amazon Corretto) earlier, but the Hadoop configuration is still looking for Java 8 in the wrong location. Let's fix this by updating the Java home path in our environment settings.
# First, let's find the correct Java installation path:

# alternatives --display java
# Or we can use:

dirname $(dirname $(readlink -f $(which java)))

# This will show us where Java is actually installed on your system. On Amazon Linux with Corretto 17, it's typically located at /usr/lib/jvm/java-17-amazon-corretto.
# Now, let's update the Java home path in your environment. We need to modify two files:

# First, update your .bash_profile:

echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> ~/.bash_profile
source ~/.bash_profile

# Then, update Hadoop's configuration:

echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
# After making these changes, verify that Java is properly configured:

echo $JAVA_HOME
# This should now show the correct path. If everything is set correctly, you can try formatting the namenode again:

hdfs namenode -format
# The error you encountered is quite common when setting up Hadoop because the Java installation path can vary between different Linux distributions and versions. The path we had in the original configuration (/usr/lib/jvm/java-1.8.0-openjdk) was the traditional path for OpenJDK 8, but since we're using Amazon Corretto 17, we needed to update this path to match your actual Java installation.

# Start HDFS services (NameNode and DataNode)
start-dfs.sh

# Start YARN services (Resource Manager and Node Manager)
start-yarn.sh


# After running these commands, check again with jps. You should see something like this:
xxxxx NameNode
xxxxx DataNode
xxxxx SecondaryNameNode
xxxxx ResourceManager
xxxxx NodeManager


# If the services don't start properly, we should check the logs. Hadoop keeps detailed logs that can tell us what's going wrong:
# Check NameNode logs
cat $HADOOP_HOME/logs/hadoop-hadoop-namenode-*.log

# Check DataNode logs
cat $HADOOP_HOME/logs/hadoop-hadoop-datanode-*.log

# One common issue that can prevent services from starting properly is incorrect directory permissions. Let's verify these:

# Check that the hadoop user owns all necessary directories
ls -l /home/hadoop/data/
# The directories should be owned by the hadoop user and have appropriate permissions (750 or 755).

# If you find only the Jps process is running, which means none of the Hadoop services are active. Let me help you systematically troubleshoot and fix this situation.
# Think of Hadoop services like a multi-story building - we need to build it from the ground up, with each level depending on the ones below it. Let's rebuild everything step by step:

# First, let's clean up any previous incomplete setup that might be causing issues:

# Stop any existing processes (though we know there aren't any running)
stop-all.sh

# Remove existing data directories to start fresh
rm -rf /home/hadoop/data/*

# Now, let's verify all our critical directories exist with proper ownership:

# Create fresh directories
mkdir -p /home/hadoop/data/namenode
mkdir -p /home/hadoop/data/datanode
mkdir -p /home/hadoop/data/tmp

# Set proper ownership and permissions
sudo chown -R hadoop:hadoop /home/hadoop/data
chmod 750 /home/hadoop/data

# Let's verify our Hadoop environment variables are set correctly. Add this to your ~/.bash_profile if not already present:

echo '# Hadoop Environment Variables' >> ~/.bash_profile
echo 'export HADOOP_HOME=/home/hadoop/hadoop' >> ~/.bash_profile
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bash_profile
echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.bash_profile
source ~/.bash_profile

# Format the HDFS system - think of this like initializing a new hard drive:

# The -force option ensures a clean format
hdfs namenode -format -force

# Start the services in the correct order:
start-dfs.sh
start-yarn.sh

# After each command, we should verify what happened. Let's check:
# Check which services are running
jps

# Look for any errors in the logs
tail -f $HADOOP_HOME/logs/hadoop-hadoop-namenode-*.log

# If you're still not seeing services start up, let's check the Hadoop configuration files one more time. I'll help you verify each one:
# Verify hadoop-env.sh has the correct Java path
echo $JAVA_HOME
cat $HADOOP_HOME/etc/hadoop/hadoop-env.sh | grep JAVA_HOME

# Check core-site.xml formatting
cat $HADOOP_HOME/etc/hadoop/core-site.xml

# Verify hdfs-site.xml
cat $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Verify all services are running
jps

# Create initial HDFS directories
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hadoop
hdfs dfs -chmod g+w /user/hadoop
