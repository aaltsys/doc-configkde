################################
 Mounting Network File Systems
################################

.. Note::
  This guide describes connecting to either local or remote server file systems 
  from Debian/Ubuntu/Mint desktops. Syntax will differ with other systems.

Using sshfs File Shares in Linux
================================

.. Note::
   Throughout these instructions, replace **HOSTSERVER**, **DOMAIN**, and 
   **TLD** with the name of the server to be accessed, the domain for the 
   server, and the top-level domain (.com, .net, etc.). For example, 
   **HOSTSERVER.DOMAIN.TLD** might be replaced with *workserver.aaltsys.com* 
   for the work server at AAltSys.

Part 1: Configure Filesystems
-----------------------------

This section configures the desktop to use remote filesystems by installing and 
loading the kernel module **fuse**, which is not included by default. Save the 
bash script :download:`fuse.sh <_downloads/fuse.sh>` to your home folder, 
open a console session, and execute the script with the command:: 

	sudo bash fuse.sh

Assign a mount point (a file directory pointer) for the remote server to use::

  sudo mkdir -p /mnt/HOSTSERVER/

Part 2. Setup Server Access
-----------------------------

This section is performed once for each remote server, to add information about 
the server to the local desktop. Instructions are provided using Domain Names. 
IP addresses would also work, but then the shares would not be accessible both 
locally and remotely. When DNS is properly configured, access works whether the 
connection is local, bridged, VPN, or public.

.. sidebar:: /etc/auto.master

	Each entry in **auto.master** defines a file access point which
	binds to a remote server. For example, file requests to
	**/mnt/HOSTSERVER** will automount **HOSTSERVER** shares. 
	Shares will be unmounted if idle for over 30 seconds.
	
	**/etc/auto.HOSTSERVER**
	
	A list of share mappings is required for each remote server.
	Here **HOSTSERVER** has two shares, **PUBLIC** and *****. Entries
	start with a name (e.g., ``public``), followed by configuration
	parameters: ``-fstype=fuse,rw,...``,
	and user ssh credentials: ``IdentityFile=$HOME/.ssh/id_rsa``.
	Last is the URI for accessing the share:
	``:sshfs\#$USER@HOSTSERVER.DOMAIN.TLD\:/.../public``.	

Add a line describing your server to **auto.master** with the following console 
command (remember, replace HOSTSERVER with your server name)::
 
  sudo bash < <(echo 'echo "/mnt/HOSTSERVER /etc/auto.HOSTSERVER --timeout=30 --ghost" >> /etc/auto.master')

Create and edit the server configuration file, **auto.HOSTSERVER**, to provide 
server-specific information::

	sudoedit /etc/auto.HOSTSERVER

and enter and save the share configuration information, such as::

	public -fstype=fuse,rw,nodev,nonempty,noatime,max_read=65536,allow_other,compression=yes,uid=$UID,gid=$GID,StrictHostKeyChecking=no,IdentityFile=$HOME/.ssh/id_rsa,umask=0007 :sshfs\#$USER@HOSTSERVER.DOMAIN.TLD\:/home/samba/shares/public/
	* -fstype=fuse,rw,allow_other,nodev,nonempty,noatime,max_read=65536,compression=yes,uid=$UID,gid=$GID,StrictHostKeyChecking=no,IdentityFile=$HOME/.ssh/id_rsa,umask=0077 :sshfs\#$USER@HOSTSERVER.DOMAIN.TLD\:/home/&

Restart the autofs module to load the changed configuration::

	sudo /etc/init.d/autofs restart
	sudo ssh HOSTSERVER.DOMAIN.TLD

When prompted for the root password of the remote host, press :kbd:`<Ctrl-C>` 
to exit the command.

Part 3. Provide your ssh key
-----------------------------

This section must be performed for each local user who will access the remote 
server. Type the following commands to (1) create an ssh private key provided 
one does not exist, and (2) copy a user public key to the remote server for 
authentication::

	if [ ! -f "$HOME/.ssh/id_rsa" ]; then ssh-keygen; fi
	ssh-copy-id `id -un`@HOSTSERVER.DOMAIN.TLD

Now verify that the remote folders will mount::

	ls -al /mnt/HOSTSERVER
	ls /mnt/HOSTSERVER/`id -un`

Create desktop links to folders in /mnt/HOSTSERVER for easy access. If the 
workstation will access the server remotely, do not create bookmarks.

When this does not work
-----------------------------

If the public folder or user home folder will not mount, try the following::

	ssh `id -un`@HOSTSERVER.DOMAIN.TLD
	chmod og-w ~
	chmod og-w ~/.ssh
	chmod 600 ~/.ssh/authorized_keys

Server SSHFS Configuration
=============================

Install authentication and sharing modules on the server as follows::

	sudo aptitude install openssh-server libpam-modules

The default server umask=0022 will shade permissions for files and folders 
created on the server. Private home folders with umask=0077 will work just 
fine, but public folders needing umask=0007 will result in incorrect 
permissions which block write access. To prevent this problem::

	sudoedit /etc/pam.d/sshd

Now add the following three lines::

  # Default umask mask for SSH/SFTP sessions
  # Shell sessions: Override with /etc/profile or ~/.bashrc or ~/.profile 
  session optional        pam_umask.so umask=0000

As noted above, actual ssh shell logins on the server will get the default 
umask=022 on new files and directories. The following command will change this 
for all shell logins::

	sudo sed -i s/umask 022/umask 0007/ /etc/profile

A logged in user could change just their own default umask with the command::

	sudo sed -i s/#umask\ 022/umask\ 0007/ ~/.profile

References:

`How to mount SFTP accesses. <http://wiki.lapipaplena.org/index.php/How_to_mount_SFTP_accesses>`_

Accessing Servers over SSH
=============================

Redirecting SSH to PuTTY
-----------------------------

PuTTY is an open-source cross-platform client for secure ssh connections with 
remote hosts. It is available on Windows, Linux, and Mac, and it is the 
preferred client on Windows. PuTTY adds power to interactive sessions. For 
example, a user can add a port forwarding rule within a running terminal session.

For a KDE desktop system derived from Debian, the following console commands 
will redirect SSH to PuTTY (courtesy of VonGrippen, AKA Michael Cochran)::
 
  sudo bash < <(wget https://raw.github.com/gist/1030236/putty-kde.sh -O-)
  sudo chmod +x /usr/bin/putty.rb

Example PuTTY Session:
-----------------------------

This program works magic which is best explained through an example, as follows.
An administrator wishes to connect to a remote Windows session running as a 
virtual machine on a Linux server. The Linux server is accessed at the domain 
name ``https://remoteserver.support.aaltsys.com``. Both the Windows session and 
the Linux server authenticate ``username`` and ``password`` for logins.

First start a console on the local machine, then ssh to the remote server::

  xdg-open ssh://`id -un`@HOSTNAME.DOMAIN.TLD

Now explore the remote environment to identify Windows RDP servers. Recommended 
commands are::

  smbclient -L NETBIOSNAME
  smbtree

These commands identify a windows session on host ``XPUSER``. Now find the IP 
for this machine using either of the commands::

  net lookup XPUSER
  nmblookup XPUSER

The remote Windows terminal server **XPUSER** uses IP **192.168.2.243** in its 
local network. Display the PuTTY menu with <Ctrl-RightClick>, and choose 
:menuselection:`Change Settings...`. Then select Category: 
:menuselection:`Connection > SSH > Tunnels` and enter::

  Source port -- 3389
  Destination -- 192.168.2.243:3389
  Click -- Add
  Click -- Apply

Finally, open the KRDC Remote Desktop client on the KDE Desktop, and connect 
to: :guilabel:`rdp` :kbd:``localhost``. A remote Windows RDP session will 
display as if it were local, being redirected to you over SSH.
