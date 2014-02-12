#!/bin/sh
# This is a shell archive.  Save it in a file, remove anything before
# this line, and then unpack it by entering "sh file".  Note, it may
# create directories; files and directories will be owned by you and
# have default permissions.
#
# This archive contains:
#
#	/usr/bin/putty.rb
#	/usr/share/kde4/services/ssh.protocol
#
# if [[ $EUID -ne 0 ]] ; then echo 'try again using sudo' ; exit 1 ; fi

echo "This script requires superuser privileges to run."
echo "Enter your password when prompted by sudo."

# clear any previous sudo permission
sudo -k

# run inside sudo
sudo sh <<SCRIPT

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
X\`"#{command.join(' ')}"\`
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
