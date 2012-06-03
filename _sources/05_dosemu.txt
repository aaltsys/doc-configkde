#####################################
 DOS programs with dosemu
#####################################

Installing DOS emulation
''''''''''''''''''''''''''''''

To install dosemu, display a terminal from :menuselection:`Accessories --> Terminal`.
Then enter the commands::

	sudo aptitude install dosemu xauth
	sudo sysctl -w vm.mmap_min_addr=0
	sudo bash < <(echo 'echo "vm.mmap_min_addr=0" >> /etc/sysctl.conf')

The DOS system can be started from :menuselection:`Applications --> System Tools --> DOS emulator`.

.. Note:: **xauth** is required for remote execution over **ssh** on Ubuntu 8.04.

DOS performance and video
''''''''''''''''''''''''''''''

Dosemu settings for each user may be set by editing configuration file ~/.dosemu::

	nano ~/.dosemurc

To make dosemu run faster, add a command::

  $_hogthreshold = (xx)

where **xx** is the percentage of CPU time to devote to dosemu (defaults to 1 percent).

To display a DOS window looking like the original DOS 640X480 EGA/VGA screen, add a command::

	 $_X_font = vga12x30

The following command will change video globally for all users (but run this only once)::

	sudo sed -i '/$_X_font/ a\$_X_font = vga12x30' /etc/dosemu/dosemu.conf

DOS video configurations include: ``vga, vga8x19, vga11x19, vga10x24, vga12x30, vga-cp866, and vga10x20-cp866``.

Running Dosemu from a Script
''''''''''''''''''''''''''''''

A DOS program may be executed from the Linux command line by calling `dosemu` followed
by the name of the DOS program (.bat, .exe, .com) to execute. If other commands are 
required in the context of the DOS program, then a shell script may perform the complete 
task. For example, the WARES program would change file permissions from public to private 
when executed by a user outside of group `__USERS__`. This can be corrected by issuing 
a `chmod` command after executing WARES. To create a shell script to include this, 
say `wares.sh`, edit the script file with `nano ~/wares.sh`::

	dosemu C:\WARES.BAT
	sudo chmod -R 777 /home/samba/shares/arev/*

Make the shell script executable with the command, `chmod +x ~/wares.sh`. Finally, execute 
the DOS session by typing `~/wares.sh` at the command line. 

Accessing Linux file shares
''''''''''''''''''''''''''''''

The dosemu command LREDIR will mount a Linux directory to a DOS drive letter. For example,::

	LREDIR W: LINUX\FS/home/samba/shares/arev 
	LREDIR S: LINUX\FS/home/samba/shares/public

A DOS batch file within dosemu can incorporate mount commands and DOS program 
execution, as illustrated previously with `C:\\WARES.BAT`. To create this batch file,
start `dosemu` and enter the file with the command `EDIT WARES.BAT`::

	LREDIR W: LINUX\FS/home/samba/shares/arev
	LREDIR S: LINUX\FS/home/samba/shares/public
	W:
	WARES.BAT WARES

Save the batch file and exit the editor with :kbd:`Alt-F,S;Alt-F,X`. Then type the
name of the batch file to test execute it. Exit the dosemu session with the command `exitemu`.



