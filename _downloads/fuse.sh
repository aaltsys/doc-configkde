#!/usr/bin/env bash

# NOTE: fuse-utils before Ubuntu 13.10, fuse after. Script tries both, depends
#       on what is in the repositories. Error messages are unimportant.

echo "Install autofs, fuse, and sshfs file systems"

# if [[ $EUID -ne 0 ]] ; then echo 'try again using sudo' ; exit 1 ; fi
# Clear and reestablish sudo privileges to run this program as root
sudo -k
echo -e "\e[1;31m Authentication required \e[0m"
sudo bash << SCRIPT

   apt-get --no-upgrade install sshfs fuse fuse-utils autofs
   modprobe --first-time fuse
   if [[ -z "$(grep 'fuse' /etc/modules)" ]] ; then 
      echo "fuse" >> /etc/modules
   fi 

SCRIPT