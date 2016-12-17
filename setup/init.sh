sudo apt-get update

# personal packages
sudo apt-get install git screen unzip

# https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-7-on-ubuntu-14-04-via-apt-get
# install tomcat
sudo apt-get install tomcat7 tomcat7-admin

# http://tecadmin.net/install-oracle-java-8-jdk-8-ubuntu-via-ppa/
# install java
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

# open /etc/default/tomcat7
# edit JAVA_HOME and JAVA_OPTS

# open /etc/tomcat7/tomcat-users.xml
# edit tomcat manager user

# https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-14-04
# install mysql 5.7
wget http://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb
sudo dpkg -i mysql-apt-config_0.6.0-1_all.deb
sudo apt-get update
sudo apt-get install mysql-server

# import my repo
cd /var/lib/tomcat7/webapps
git clone repo
