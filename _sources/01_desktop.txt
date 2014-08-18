############################# 
 Desktop Configuration
############################# 

Install Software Packages
=============================

There is a whole slew of software one would want on a computer for writing, 
graphic arts, and so forth. The selection of available packages changes with 
each operating system version. The easiest way to install the packages for a 
particular version is through a script, and scripts are provided for many 
recent system releases.

Desktop scripts by version
-----------------------------

Install a script as follows. First, download the script file appropriate for 
your system, saving it to file :file:`first-install.sh` in your home folder:

+ :download:`KDE/Mint 12 desktop </_downloads/KDE-Mint_12-desktop.sh>`
+ :download:`KUbuntu 12/Mint 13 desktop </_downloads/KUbuntu_12-desktop.sh>`
+ :download:`KUbuntu 13 desktop </_downloads/KUbuntu_13-desktop.sh>`

.. Tip:: If your browser saved this file without asking you where to put it or 
   what to name it, then edit your browser preferences to always ask when 
   saving downloads.

Now perform the following:

#. Open a console (terminal) window
#. Type the command :command:`sudo bash first-install.sh <Enter>`
#. Enter your password when asked
#. When asked for a mysql pasword, type :kbd:`mysql`
#. Wait an hour or so while over 1000 software packages are installed
#. Restart your system to load updates to the Linux kernel

Install ReST, Sphinx tools
-----------------------------

Install documentation tools with the following separate script:

#. Download :download:`reST script </_downloads/rest-install.sh>` to filename 
   :file:`rest-install.sh`
#. Open a console (terminal) window
#. Type the command :command:`sudo bash rest-install.sh <Enter>`
#. Enter your password when asked
#. Wait an hour or so while packages are installed and compiled

Configure Workspaces
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

Configure Clipboard, Editor
=============================

+ Click the scissors on the task bar, and choose :guilabel:`Configure Klipper...`.
+ On the :guilabel:`General` tab, check the box labeled 
  :guilabel:`Synchronize contents of the clipboard and the selection`.

+ Open the editor `Kate`.
+ On :menuselection:`View --> Tool Views`, Check all three options:
  :menuselection:`Show Sidebars`, :menuselection:`Show Documents`,
  :menuselection:`Show Terminal`.

Avoiding VIM
=============================

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
  
  #. display current keyboard state (1=off, 2=on):
  
     cat /sys/module/hid_apple/parameters/fnmode 
     
  #. set keyboard state to 2 (on):
  
     echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
     
  #. make the configuration change permanent version 1 (not working on Mint 12):
  
     sudo touch /etc/sysfs.conf
     sudo bash < <(echo 'echo "module/hid_apple/parameters/fnmode = 2" >> /etc/sysfs.conf')
     
  #. make configuration change permanent, version 2
  #. still working on this, as it must come before "exit 0":
  
     sudo bash < <(echo 'echo "echo 2 > /sys/module/hid_apple/parameters/fnmode" >> /etc/rc.local')

References:

`AppleKeyboard <https://help.ubuntu.com/community/AppleKeyboard>`_
