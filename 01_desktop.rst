############################# 
 Desktop Configuration
############################# 

Software Installation
=============================

Download and run scripts as provided from http://publish.lovels.us:

Software first install script:

  http://publish.lovels.us/_downloads/KDE-Mint_12-desktop.sh

Software rest install script:

  http://publish.lovels.us/_downloads/rest-install.sh

Other software install (left out of first script):

  sudo aptitude install krdc remmina

A desktop icon can call a remote with the command:

  remmina -c {remotename}

Desktop Configuration
=============================

Click the cashew on the menu bar at the right, and add widgets:
  
  Lancelot Launcher
  Pager

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