#####################################
 DOS programs with dosemu
#####################################

Installing DOS emulation
=============================

Install dosemu at a console, :menuselection:`Accessories --> Terminal`, with 
the commands::

   sudo aptitude install dosemu xauth
   sudo sysctl -w vm.mmap_min_addr=0
   sudo bash < <(echo 'echo "vm.mmap_min_addr=0" >> /etc/sysctl.conf')

The DOS system can be started from 
:menuselection:`Applications --> System Tools --> DOS emulator`.

.. Note:: 
   **xauth** is required for remote X11 execution over **ssh**. Some versions of
   Ubuntu (8.04, for example) omit this package.

DOS performance and video
=============================

Change :program:`dosemu` configuration with commands to edit either global 
configuration file :command:`sudoedit /etc/dosemu/dosemu.conf` or user file
:command:`nano ~/.dosemurc`.

Emulate the DOS 640X480 EGA/VGA display with the command::

   echo '$_X_font = vga12x30' >> ~/.dosemurc

The following command would change this setting globally for all users::

   sudo sed -ie "/$_X_font/c\$_X_font = vga12x30" /etc/dosemu/dosemu.conf

.. note::
   DOS video configurations include: 
   ``vga, vga8x19, vga11x19, vga10x24, vga12x30, vga-cp866, and vga10x20-cp866``.

To make dosemu run faster for the current user, add a command:: 

   echo '$_hogthreshold = (xx)' >> ~/.dosemurc

where **xx** is the percentage of CPU time to devote to dosemu, which defaults 
to 1 percent.

Running Dosemu
=============================

Interactive DOSemu sessions
-----------------------------

To start an interactive DOSemu session, type :command:`dosemu` at the console 
or select :menuselection:`Applications --> System --> DOS emulator` from the
system menu. 

Exit the command line of an interactive session by typing :command:`exitemu`
or by pressing :kbd:`Control-Alt-PgDn`.

Keyboard Capture
-----------------------------

Press :kbd:`<Shift-Ctrl-Alt-K>` to switch into and out of keygrab mode in 
DOSEMU. The :kbd:`<Shift>` is required in KDE, optional in Gnome and maybe
other desktops.

DOS program sessions
-----------------------------

A DOS program may be executed from the Linux command line by calling 
:command:`dosemu` followed by the name of the DOS program (.bat, .exe, .com) 
to execute. When the called program exits in DOSemu, the DOSemu session will 
close.

Scripted DOSemu sessions
-----------------------------

If other commands are required in the context of the DOS program, then a 
shell script may perform the complete task. For example, suppose program 
**WARES** would change shared file permissions from public to private when 
executed by a user not in group `__USERS__`. Issuing a :command:`chmod` 
command after executing WARES would fix permissions. A script :file:`wares.sh` 
for this purpose could be created with command :command:`nano ~/wares.sh`::

   dosemu C:\WARES.BAT
   sudo chmod -R 777 /home/samba/shares/wares/*

Make the shell script executable with command :command:`chmod +x ~/wares.sh`. 
Finally, run the DOS session by typing :command:`~/wares.sh` at the console. 

Accessing Linux file shares
=============================

The dosemu command :command:`LREDIR` will mount a Linux directory to a DOS 
drive letter; for example::

   LREDIR W: LINUX\FS/home/samba/shares/wares 
   LREDIR S: LINUX\FS/home/samba/shares/public

A DOS batch file within dosemu can incorporate mount commands and DOS program 
execution, as illustrated previously with `C:\\WARES.BAT`. To create this batch 
file, start :command:`dosemu` and enter the file with the command 
:command:`EDIT WARES.BAT`::

   LREDIR W: LINUX\FS/home/samba/shares/wares
   LREDIR S: LINUX\FS/home/samba/shares/public
   W:
   WARES.BAT WARES

Save the batch file and exit the editor with :kbd:`<Alt-F>,S;<Alt-F>,X`. Then 
type the name of the batch file to execute it. 

