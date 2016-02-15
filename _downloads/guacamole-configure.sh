#!/bin/bash

# Program to configure Guacamole Client on Ubuntu

echo "Add Remote Client Configuration to Guacamole"

# write configuration file
cat > /etc/guacamole/guacamole.properties << CONF
   guacd-hostname:      localhost
   guacd-port:          4822
   user-mapping:        /etc/guacamole/user-mapping.xml
   auth-provider:       net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
   basic-user-mapping:  /etc/guacamole/user-mapping.xml
CONF

exit
