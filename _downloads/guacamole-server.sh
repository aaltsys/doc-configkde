#!/bin/bash

# one-time program to setup Guacamole Server and Client on Ubuntu

if [[ $EUID -ne 0 ]] ; then echo -e '\e[1;31m try again using sudo \e[0m' ; exit 1 ; fi

echo "Installing Guacamole Server and Client on Ubuntu"

# install dependencies
apt-get -y install libcairo2-dev libjpeg62-dev libpng12-dev libossp-uuid-dev 
apt-get -y install libfreerdp-dev libpango1.0-dev libssh2-1-dev libssh-dev 
apt-get -y install tomcat7 tomcat7-admin tomcat7-user 
apt-get -y update

# download and extract Guacamole tarball
wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.9.tar.gz 
tar zxf guacamole-server-0.9.9.tar.gz 

# compile the server
cd guacamole-server-0.9.9 
./configure 
make
make install
ldconfig

# download and rename client

cd /var/lib/tomcat7
wget http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-0.9.9.war
mv guacamole-0.9.9.war guacamole.war

# create the configuration file
mkdir /etc/guacamole
mkdir /usr/share/tomcat7/.guacamole

# write the configuration

echo >> /etc/guacamole/guacamole.properties << CONF
   guacd-hostname:      localhost
   guacd-port:          4822
   user-mapping:        /etc/guacamole/user-mapping.xml
   auth-provider:       net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
   basic-user-mapping:  /etc/guacamole/user-mapping.xml
CONF

# create a symbolic link to configuration for tomcat:
ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat7/.guacamole/

echo "\e[1;31m Finished installing guacamole server and client. \e[0m"
echo "\e[1;31m Now create the file 'user-mapping.xml'. \e[0m"

exit
