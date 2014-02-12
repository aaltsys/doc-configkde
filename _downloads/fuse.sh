#!/usr/bin/env bash

echo "This script requires superuser privileges to run."
echo "Enter your password when prompted by sudo."

# clear any previous sudo permission
sudo -k

# run inside sudo
sudo sh <<SCRIPT

   apt-get --no-upgrade install sshfs fuse-utils autofs
   modprobe --first-time fuse
   if [ $? -eq 0 ] ; then 
      echo "fuse" >> /etc/modules
   fi 

SCRIPT