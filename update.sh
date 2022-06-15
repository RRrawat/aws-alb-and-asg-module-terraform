#!/bin/bash -v

sudo su -
cd /opt
amazon-linux-extras install java-openjdk11 -y
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.60/bin/apache-tomcat-9.0.60.tar.gz
tar -xvzf /opt/apache-tomcat-9.0.60.tar.gz
mv apache-tomcat-9.0.60 tomcat
chown ec2-user /opt/tomcat/webapps
ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown
tomcatup
cd ..
