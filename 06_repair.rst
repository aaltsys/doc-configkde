.. _repair:

#############################
Repairing Problems
#############################

Reinstalling GRUB2
=============================

A volume copy, Windows install, or other operation might overwrite the MBR on a 
boot device, preventing GRUB from loading. The simplest solution to restore GRUB 
is to reinstall it. This requires a current installation disk or boot device.

Boot the computer from installation media, and proceed to the desktop rather 
than selecting install. Choose :menuselection:`System --> Terminal` from the 
desktop menu to display a console window. Then type the following commands::

   sudo mount /dev/sdLX /mnt
   sudo grub-install --root-directory=/mnt /dev/sdL
   sudo reboot

where the **L** and **X** of **sdLX** and **sdL** should be replaced by:

*  L = the boot device letter, found from either :command:`ls /dev/sd*` or 
   :command:`sudo blkid`
*  X = the boot volume number on the boot device, as found previously.

.. tip:
   Remember to remove the installation media during the reboot.

Awkward Messages
=============================

QFileSystemWatcher message
-----------------------------

Messages from QFileSystemWatcher can be eliminated with::
  
   mkdir -p ~/.config/ibus/bus 
