#!/usr/bin/env bash
apt-get --no-upgrade install sshfs fuse-utils autofs
modprobe --first-time fuse
if [ $? -eq 0 ]
then
  echo "fuse" >> /etc/modules
fi 
