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

# Start Hadoop services
start-dfs.sh
start-yarn.sh

# Verify all services are running
jps

# Create initial HDFS directories
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hadoop
hdfs dfs -chmod g+w /user/hadoop
