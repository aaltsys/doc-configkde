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

.. Note:: **xauth** is required for remote execution over **ssh** on Ubuntu 8.04.

DOS performance and video
-----------------------------

Dosemu configuration may be set either globally or for each user. User settings 
are stored in configuration file :file:`~/.dosemurc`, while global settings are 
kept in :file:`/etc/dosemu/dosemu.conf`. One-time commands are shown following; 
make testing and ongoing changes with editing commands 
:command:`sudoedit /etc/dosemu/dosemu.conf` (global) or 
:command:`nano ~/.dosemurc` (per user).

To make dosemu run faster, change the hogthreshold :kbd:`xx` with the command:: 

	echo '$_hogthreshold = (xx)' >> ~/.dosemurc

where **xx** is the percentage of CPU time to devote to dosemu, which defaults 
to 1 percent.

Emulate the DOS 640X480 EGA/VGA display with the command::

	echo '$_X_font = vga12x30' >> ~/.dosemurc

The following command would change video globally for all users (but run this 
only once)::

	sudo sed -i '/$_X_font/ a\$_X_font = vga12x30' /etc/dosemu/dosemu.conf

DOS video configurations include: vga, vga8x19, vga11x19, vga10x24, vga12x30, 
vga-cp866, and vga10x20-cp866.

Running Dosemu
=============================

Interactive DOSemu sessions
-----------------------------

To start an interactive DOSemu session, type :command:`dosemu` at the console 
or select :menuselection:`Applications --> System --> DOS emulator` from the
system menu. To exit the command line of an interactive session, type the
command :command:`exitemu`.

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




