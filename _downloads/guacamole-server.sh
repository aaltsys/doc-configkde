#!/bin/bash

# one-time program to setup Guacamole Server on Ubuntu

echo "Installing Guacamole Server on Ubuntu"

# if [[ $EUID -ne 0 ]] ; then echo -e "\e[1;31m try again using sudo \e[0m" ; exit 1 ; fi

sudo bash << SERVER

   # install dependencies
   apt-get install libcairo2-dev libjpeg62-dev libpng12-dev libossp-uuid-dev 
   apt-get install libfreerdp-dev libpango1.0-dev libssh2-1-dev libssh-dev 
   apt-get install tomcat7 tomcat7-admin tomcat7-user 

   # download and extract Guacamole tarball
   wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.9.tar.gz 
   tar zxf guacamole-server-0.9.9.tar.gz 

   # compile the server
   cd guacamole-server-0.9.9 
   ./configure 
   make
   make install
   ldconfig

SERVER

# one-time program to setup Guacamole Client on Ubuntu

echo "Install Guacamole Client on Ubuntu"

# download and rename client

cd /var/lib/tomcat7
wget http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-0.9.9.war
mv guacamole-0.9.9.war guacamole.war

# create the configuration file

mkdir /etc/guacamole
mkdir /usr/share/tomcat7/.guacamole

# write the configuration
echo /etc/guacamole/guacamole.properties << CONF
   guacd-hostname:      localhost
   guacd-port:          4822
   user-mapping:        /etc/guacamole/user-mapping.xml
   auth-provider:       net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
   basic-user-mapping:  /etc/guacamole/user-mapping.xml
CONF

# create a symbolic link to configuration for tomcat:
ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat7/.guacamole/

exit
