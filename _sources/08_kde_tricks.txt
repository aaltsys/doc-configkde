#############################
 KDE Desktop Management
#############################

Avoiding VIM
=============================

Change default editor in KDE with the command::

  sudo update-alternatives --config editor

Change default editor when opening files in Dolphin:

+ Right-click on file, choose :menuselection:`Properties`
+ Click on the wrench to the right of :guilabel:`file type`
+ Click on your preferred editor in the 
  :guilabel:`Application Preference Order` list
+ Click :guilabel:`Move Up` to move your preference up the list
+ Click :guilabel:`Apply`, then close the properties window.

Apple Keyboard function keys
=============================

On recent KDE desktops (11.04+), issue the commands::

  sudo sed -i "$ s#exit 0#echo 2 > /sys/module/hid_apple/parameters/fnmode\n\nexit 0#" /etc/rc.local
  echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode

Your Apple Aluminum keyboard will work correctly in all programs.
  
On older Ubuntu and variants, try out commands such as::

  # display current keyboard state (1=off, 2=on)
  cat /sys/module/hid_apple/parameters/fnmode 
  # set keyboard state to 2 (on)
  echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
  # make the configuration change permanent
  sudo touch /etc/sysfs.conf
  sudo bash < <(echo 'echo "module/hid_apple/parameters/fnmode = 2" >> /etc/sysfs.conf')
  
On Ubuntu 11.10 and later, set the type of Apple keyboard with the following commands::
  
  sudo bash < <(echo 'echo options hid_apple iso_layout=0 | sudo tee -a /etc/modprobe.d/hid_apple.conf')
  sudo update-initramfs -u -k all
  
References:

`AppleKeyboard <https://help.ubuntu.com/community/AppleKeyboard>`_