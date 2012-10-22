############################# 
 Desktop Configuration
############################# 

Software Installation
=============================

Installation of Linux and scripted OS configuration is described at 
http://publish.lovels.us/02_installation.html.

Desktop Configuration
=============================

For laptops and netbooks, the workspace type may default to *Netbook*. This is 
changed as follows:

+ Open *System Settings*
+ Under *Workspace Appearance and Behavior*, open *Workspace Behavior*
+ Click the *Workspace* cashew icon
+ Click the droplist next to *Workspace Type:* and select *Desktop*
+ Click the *Apply* button in the bottom-right of the window
+ Close *System Settings*

Add an improved system menu and multi-workspace paging as follows:

+ Click the configuration cashew at the right on the menu bar
+ Click *+ add widgets...*
+ Add *Lancelot Launcher*, remove *Application Launcher*
+ If missing, add *Pager* (already installed on KUbuntu; not installed on Mint) 

Avoiding VIM
=====================================

Change default editor in KDE with the command::
  
  sudo update-alternatives --config editor

Change default editor when opening files in Dolphin:

+ Right-click on file, choose *Properties*
+ Click on the wrench to the right of *file type*
+ Click on your preferred editor in the *Application Preference Order* list
+ Click *Move Up* to move your preference up the list
+ Click *Apply*, then close the properties window.

Turn on Apple Keyboard function keys
=====================================

::
  
  # display current keyboard state (1=off, 2=on)
  cat /sys/module/hid_apple/parameters/fnmode 
  # set keyboard state to 2 (on)
  echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
  # make the configuration change permanent version 1 (not working on Mint 12)
  sudo touch /etc/sysfs.conf
  sudo bash < <(echo 'echo "module/hid_apple/parameters/fnmode = 2" >> /etc/sysfs.conf')
  # make configuration change permanent, version 2
  # still working on this, as it must come before "exit 0"
  sudo bash < <(echo 'echo "echo 2 > /sys/module/hid_apple/parameters/fnmode" >> /etc/rc.local')

References:

`AppleKeyboard <https://help.ubuntu.com/community/AppleKeyboard>`_

Fixing bugs
==================================

QFileSystemWatcher messages
----------------------------------

Messages from QFileSystemWatcher can be eliminated with::
  
  mkdir -p ~/.config/ibus/bus