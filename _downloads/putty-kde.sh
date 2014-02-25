#!/bin/bash

echo "Setup putty to handle ssh URLs in terminal, not browser"

# This archive contains:
#
#	/usr/bin/putty.rb
#	/usr/share/kde4/services/ssh.protocol
#
# if [[ $EUID -ne 0 ]] ; then echo 'try again using sudo' ; exit 1 ; fi
# Clear and reestablish sudo privileges to run this program as root
sudo -k
echo -e "\e[1;31m Authentication required \e[0m"
sudo sh << SCRIPT

apt-get -y install ruby-full putty

echo x - /usr/bin/putty.rb
sed 's/^X//' >/usr/bin/putty.rb << 'END-of-/usr/bin/putty.rb'
X#!/usr/bin/env ruby
X
Xrequire 'uri'
X
Xuri=URI.parse(ARGV[0])
Xcommand = Array.new
Xcommand << \`which putty\`.gsub("\n", "")
Xcommand << "-l #{uri.user}" if uri.user
Xcommand << "-P #{uri.port}" if uri.port
Xcommand << "-#{uri.scheme}" if uri.scheme
Xcommand << "#{uri.host}"
X
X\`#{command.join(" ")}\`
END-of-/usr/bin/putty.rb

echo x - /usr/share/kde4/services/ssh.protocol
sed 's/^X//' >/usr/share/kde4/services/ssh.protocol << 'END-of-/usr/share/kde4/services/ssh.protocol'
X[Protocol]
Xexec=putty.rb %u
Xprotocol=ssh
Xinput=none
Xoutput=none
Xhelper=true
Xlisting=false
Xreading=false
Xwriting=false
Xmakedir=false
Xdeleting=false
XIcon=application-x-deb
XClass=:internet
END-of-/usr/share/kde4/services/ssh.protocol

chmod +x /usr/bin/putty.rb

SCRIPT

exit
