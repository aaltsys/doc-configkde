############################# 
 Desktop Configuration
############################# 

Software Installation
=============================

Download and run scripts as provided from http://publish.lovels.us:

Main software install script:

  http://publish.lovels.us/_downloads/KDE-Mint_12-desktop.sh

Rest install script:

  http://publish.lovels.us/_downloads/rest-install.sh

Desktop Configuration
=============================

Click the cashew on the menu bar at the right, and add widgets:
  
  Lancelot Launcher
  Pager

Understanding SSH keys
=============================

Each user on each system has a unique ssh key configuration. A user should 
create a key set with the command::

  if [ ! -f "$HOME/.ssh/id_rsa" ]; then ssh-keygen; fi

Keys are stored in the files

+ private key: :file:`~/.ssh/id_rsa`
+ public key:  :file:`~/.ssh/id_rsa.pub`
+ known hosts: :file:`~/.ssh/known_hosts`

In /etc/ssh/ssh_config, comment out the line ``HashKnownHosts yes`` with the 
following command:

  sudo sed "s/    HashKnown/#   HashKnown/" /etc/ssh/ssh_config

Replace ssh with PuTTY as default ssh:// handler with the command:

  sudo bash < <(wget https://raw.github.com/gist/1030236/putty-kde.sh -O-)

Secure web services
-----------------------------

Many web services require ssh keys, and they are generally installed through 
cut-and-paste. Display the key using the command:

  kate ~/.ssh/id_rsa.public

Press :kbd:`<Ctrl-A><Ctrl-C>` to copy, and paste the key to the web page with 
:kbd:`<Ctrl-V>`.

Remote file access
-----------------------------

Add an ssh key to a remote server for file access with the command::

  ssh-copy-id `id -un`@HOSTSERVER.DOMAIN.TLD

replacing HOSTSERVER.DOMAIN.TLD with the server's fully qualified domain name.

Avoiding VIM
=====================================

Change default editor in KDE with the command:

| sudo update-alternatives --config editor

Change default editor when opening files in Dolphin:

| Right-click on file, choose *Properties*
| Click on the wrench to the right of *file type*
| Click on your preferred editor in the *Application Preference Order* list
| Click *Move Up* to move your preference up the list
| Click *Apply*, then close the properties window.

Turn on Apple Keyboard function keys
=====================================

| # display current keyboard state (1=off, 2=on)
| cat /sys/module/hid_apple/parameters/fnmode 
| # set keyboard state to 2 (on)
| echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
| # make the configuration change permanent version 1 (not working on Mint 12)
| sudo touch /etc/sysfs.conf
| sudo bash < <(echo 'echo "module/hid_apple/parameters/fnmode = 2" >> /etc/sysfs.conf')
| # make configuration change permanent, version 2
| # still working on this, as it must come before "exit 0"
| sudo bash < <(echo 'echo "echo 2 > /sys/module/hid_apple/parameters/fnmode" >> /etc/rc.local')

References:

`AppleKeyboard <https://help.ubuntu.com/community/AppleKeyboard>`_

Fixing bugs
==================================

QFileSystemWatcher messages
----------------------------------

Messages from QFileSystemWatcher can be eliminated with:

 mkdir -p ~/.config/ibus/bus