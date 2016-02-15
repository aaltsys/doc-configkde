#!/bin/bash

if [[ $EUID -ne 0 ]] ; then echo -e '\e[1;31m try again using sudo \e[0m' ; exit 1 ; fi

# Program to configure Guacamole Client on Ubuntu

echo "Add Remote Client Configuration to Guacamole"

# write configuration file
cat > /etc/guacamole/guacamole.properties << '_CONF'
guacd-hostname:      localhost
guacd-port:          4822
user-mapping:        /etc/guacamole/user-mapping.xml
auth-provider:       net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping:  /etc/guacamole/user-mapping.xml
_CONF

exit
