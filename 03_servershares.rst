################################
Mounting Network File Systems
################################

.. note::
  This guide describes connecting to either local or remote computer systems 
  from Debian/Ubuntu/Mint desktops. Syntax will differ with other systems.

Using sshfs File Shares in Linux
================================

.. note::
   Throughout these instructions, replace **HOSTNAME**, **DOMAIN**, and 
   **TLD** with the host computer name to be accessed, the domain for the 
   host computer, and the top-level domain (.com, .net, etc.). For example, 
   **HOSTNAME.DOMAIN.TLD** might be replaced with *workserver.github.com* 
   for the work server at GitHub.

Part 1: Configure Filesystems
-----------------------------

This section configures the desktop to use remote filesystems by installing and 
loading the kernel module **fuse**, which is not included by default. Save the 
bash script :download:`fuse.sh <_downloads/fuse.sh>` to your home folder, 
open a console session, and execute the script with the command:: 

   sudo bash fuse.sh

Assign a local mount point (a file directory pointer) for shares on the remote 
computer::

   sudo mkdir -p /mnt/HOSTNAME/

Part 2. Setup Server Access
-----------------------------

.. sidebar:: /etc/auto.master
   
   Each entry in **auto.master** defines a file access point which binds to a 
   remote computer. For example, file requests to **/mnt/HOSTNAME** will 
   automount **HOSTNAME** shares. 	Shares will be unmounted if idle for over 
   30 seconds.
   
   **/etc/auto.HOSTNAME**
   
   A list of share mappings is required for each remote computer. Here 
   **HOSTNAME** has two shares, **PUBLIC** and remote user home folder *****. 
   Entries start with a name (e.g., ``public``), followed by configuration
   parameters, user ssh credentials, and the URI for accessing the share.

This section is performed once for each remote computer, to add information 
about the computer to the local desktop. Instructions are provided using Domain 
Names. IP addresses would also work, but then the shares would not be 
accessible both locally and remotely. When DNS is properly configured, access 
works whether the connection is local, bridged, VPN, or public.

Add a line describing a computer to **auto.master** with the following console 
command (remember, replace HOSTNAME with the computer name)::
 
   sudo bash < <(echo 'echo "/mnt/HOSTNAME /etc/auto.HOSTNAME --timeout=30 --ghost" >> /etc/auto.master')

Create and edit the host computer configuration file, :file:`auto.HOSTNAME`, to 
provide share-specific information::

   sudoedit /etc/auto.HOSTNAME

and enter and save the share configuration information, such as::

   public -fstype=fuse,rw,nodev,nonempty,noatime,max_read=65536,allow_other,compression=yes,uid=$UID,gid=$GID,StrictHostKeyChecking=no,IdentityFile=$HOME/.ssh/id_rsa,umask=0007 :sshfs\#$USER@HOSTNAME.DOMAIN.TLD\:/home/samba/shares/public/
   * -fstype=fuse,rw,allow_other,nodev,nonempty,noatime,max_read=65536,compression=yes,uid=$UID,gid=$GID,StrictHostKeyChecking=no,IdentityFile=$HOME/.ssh/id_rsa,umask=0077 :sshfs\#$USER@HOSTNAME.DOMAIN.TLD\:/home/&

Restart the autofs module to load the changed configuration::

   sudo service autofs restart
   sudo ssh HOSTNAME.DOMAIN.TLD

When prompted for the root password of the remote host, press :kbd:`<Ctrl-C>` 
to exit the command.

Part 3. Provide your ssh key
-----------------------------

This section must be performed for each local user who will access the remote 
computer. Type the following commands to (1) create ssh keys provided a set 
does not exist, and (2) copy the user public key to the remote computer for 
authentication::

   if [ ! -f "$HOME/.ssh/id_rsa" ]; then ssh-keygen; fi
   ssh-copy-id `id -un`@HOSTNAME.DOMAIN.TLD

Now verify that the remote folders will mount::

   ls -al /mnt/HOSTNAME
   ls /mnt/HOSTNAME/`id -un`

Create desktop links to folders in :file:`/mnt/HOSTNAME` for easy access. On 
workstations which might access servers remotely over slow Internet links, do 
not create bookmarks.

When this does not work
-----------------------------

If the public folder or user home folder will not mount, try the following::

   ssh `id -un`@HOSTNAME.DOMAIN.TLD
   chmod og-w ~
   chmod og-w ~/.ssh
   chmod 600 ~/.ssh/authorized_keys

Server SSHFS Configuration
=============================

Install authentication and sharing modules on the remote server as follows::

   sudo aptitude install openssh-server libpam-modules

The default host umask=0022 will shade permissions for files and folders 
created on the remote shares. Private home folders with umask=0077 will work 
just fine, but public folders needing umask=0007 will result in incorrect 
permissions which block write access. To prevent this problem::

   sudoedit /etc/pam.d/sshd

Now add the following three lines::

   # Default umask mask for SSH/SFTP sessions
   # Shell sessions: Override with /etc/profile or ~/.bashrc or ~/.profile 
   session    optional     pam_umask.so umask=0000

As noted above, actual ssh shell logins on the remote host will get the default 
umask=022 on new files and directories. The following command will change this 
for all shell logins::

   sudo sed -i s/umask 022/umask 0007/ /etc/profile

A logged in user could change just her own default umask with the command::

   sudo sed -i s/#umask\ 022/umask\ 0007/ ~/.profile

References:

`How to mount SFTP accesses. <http://wiki.lapipaplena.org/index.php/How_to_mount_SFTP_accesses>`_

SSH Remote Consoles
=============================

A favorite Windows consultant expression is, "Just telnet into the server." 
:command:`Telnet` has been deprecated for a very long time in the Linux world. 
Instead, :command:`ssh` provides encrypted communications for remote access 
over insecure channels such as the Internet. We recommend using the 
:command:`PuTTY` utility to manage :command:`ssh` sessions on all platforms.

Redirecting SSH to PuTTY
-----------------------------

PuTTY is an open-source cross-platform client for secure ssh connections with 
remote hosts. It is available on Windows, Linux, and Mac, and it is the 
preferred client on Windows. PuTTY adds power to interactive sessions. For 
example, a user can add a port forwarding rule within a running terminal session.

For a KDE desktop system derived from Debian, the following console commands 
will redirect SSH to PuTTY (courtesy of VonGrippen, AKA Michael Cochran)::
 
   bash < <(wget http://git.io/kde-putty -O-)

Test the command's result in your browser with the following link::

   ssh://github.com

.. note:: The URL http://git.io/kde-putty points to the source file at
   https://raw.github.com/aaltsys/doc-configkde/master/_downloads/putty-kde.sh.
   The URL shortening command was 
   :command:`curl -i http://git.io -F "url=https://raw.github.com/aaltsys/doc-configkde/master/_downloads/putty-kde.sh" -F "code=kde-putty"`

Example PuTTY Session:
-----------------------------

This program works magic which is best explained through an example, as follows.
An administrator wishes to connect to a remote Windows session running on a 
network behind a Linux server. The Linux server is accessed at the domain 
name ``https://HOSTNAME.DOMAIN.TLD``. Both the Windows session and the Linux 
server authenticate ``username`` and ``password`` for logins.

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

Suppose the remote Windows terminal server **XPUSER** uses IP **192.168.2.243** 
in its local network. Display the PuTTY menu with :kbd:`<Ctrl-RightClick>`, and 
choose :menuselection:`Change Settings...`. Then select Category: 
:menuselection:`Connection > SSH > Tunnels` and enter:

| Source port: :kbd:`3389`
| Destination: :kbd:`192.168.2.243:3389`
| Click -- :kbd:`Add`
| Click -- :kbd:`Apply`

Finally, open the KRDC Remote Desktop client on the KDE Desktop, and connect 
using protocol :kbd:`rdp` to :kbd:`localhost`. A remote Windows RDP session 
will display as if it were local, being redirected to you over SSH.

Using SAMBA4 Shares
=============================

Configuring Ubuntu desktop
-----------------------------

The computer hostname must be valid for Windows; meaning it must start with a 
letter, and only characters :kbd:`A-Z`, :kbd:`0-9`, or :kbd:`._` are allowed. 
Edit the host/hostname configuration using the command::

   sudo nano /etc/hosts /etc/hostname

Next install :program:`samba4` with the command::

   sudo apt-get install samba4

Set the workgroup or domain for the computer with the command::

   (commands not found)

