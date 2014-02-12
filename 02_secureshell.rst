######################################
 Remote Secure Shell Sessions
######################################

.. Note::
   Throughout these instructions, replace **HOSTNAME**, **DOMAIN**, and 
   **TLD** with the name of the computer to be accessed, the domain for the 
   computer, and the top-level domain (.com, .net, etc.). For example, 
   **HOSTNAME.DOMAIN.TLD** might be replaced with **workserver.github.com** 
   for the work server at GitHub.

Understanding SSH keys
=============================

.. sidebar:: Credentials Index
  
  Each workstation or server in a network should have a unique computer name, 
  and users on a system should have their own usernames. On this premise, the 
  combined computername/username should be unique or uncommonly duplicated 
  across a computer network. This makes credential management more transparent.

SSH is a free, open-source public key credential and encryption system which 
forms the basis for secure communication on Internet Protocol networks. SSH 
credential keys are indexed to the combination of computername/username, as 
mentioned in the sidebar. This permits authorizing system access while offering 
a mechanism to reject credentials for specific computername/usernames, as when 
a computer is stolen. 

Configuring SSH for a user
=============================

Each user should create a key set with the command::

  if [ ! -f ~/.ssh/id_rsa ]; then ssh-keygen -N '' -f ~/.ssh/id_rsa; fi

Resulting keys are stored in the files

+ private key: :file:`~/.ssh/id_rsa`
+ public key:  :file:`~/.ssh/id_rsa.pub`
+ known hosts: :file:`~/.ssh/known_hosts`

List the hidden :file:`.ssh` directory to see the permissions::

  ls -al ~/.ssh

Recommended configuration
-----------------------------

On each computer, comment out the line :command:`HashKnownHosts yes` in file 
:file:`/etc/ssh/ssh_config` with the following command::

  sudo sed -i "s/    HashKnown/#   HashKnown/" /etc/ssh/ssh_config

Using SSH in web browsers
-----------------------------

Replace :command:`ssh` with :command:`PuTTY` as the default :command:`ssh\://` 
handler for your browser with the command::

   bash < <(wget http://git.io/kde-putty -O-)

Test this configuration in your browser by going to the link address::

   ssh://github.com

.. note::
  Firefox requires you to type in the program name to handle ssh, 
  :command:`xdg-open`. Google Chrome's omnisearch box is a serious hindrance 
  with ssh links, but will work. GitHub will not log you in over ssh, of 
  course.

Press :kbd:`<Ctrl-RightClick>` to change PuTTY settings in a running session. 
Make changes permanent by saving :menuselection:`Session --> Default Settings`. 

Commands to install keys
-----------------------------

Where a user has login privileges on a system, add an ssh key to the remote 
system for secure access with the command::

  ssh-copy-id `id -un`@HOSTNAME.DOMAIN.TLD

replacing HOSTNAME.DOMAIN.TLD with the computer's fully qualified domain name.

Secure web services
-----------------------------

Many web services which require ssh keys, such as GitHub, install keys through 
cut-and-paste. Display a user's local public key using the command::

  kate ~/.ssh/id_rsa.pub

In Kate, press :kbd:`<Ctrl-A><Ctrl-C>` to copy, and paste the key to the web 
page with :kbd:`<Ctrl-V>`.

Managing Changed SSH Keys
=============================

An :command:`ssh` session may abort when starting. The most likely cause for 
this is a changed ssh key on either the local or the remote system. Address 
this problem in a console session. When a new key is created on the local 
system, copy the key to the remote system with the :command:`ssh-copy-id` 
command as described above. 

If a remote system key is changed, connect to the remote system with::

  ssh `id -un`@HOSTNAME.DOMAIN.TLD

A console message will identify the line number in :file:`~/.ssh/known_hosts` 
file which contains an invalid key. Delete this line with the command::

  sed -i '[linenumber]d' ~/.ssh/known_hosts

where the expression ``[linenumber]`` is replaced with a line number.

Then reconnect from the console, and save the new key when prompted.

Remote logins over ssh
=============================

Basic:
-----------------------------

From a console session, login to a remote system with the command::

	ssh `id -un`@HOSTNAME.DOMAIN.TLD


Port forwarding for RDP:
-----------------------------

::

	ssh -L3389:[remoteIP]:3389 [username]@HOSTNAME.DOMAIN.TLD

Display the forwarded :command:`RDP` session in :command:`Remmina` or 
:command:`KRDC`.

Gnome terminal
-----------------------------

NX performing X-11 Forwarding with gnome-terminal::

	gnome-terminal -x ssh -L8889:localhost:8888 [username]@HOSTNAME.DOMAIN.TLD

KDE PuTTY
-----------------------------

Select :menuselection:`Applications --> Internet --> PuTTY SSH Client` from the 
menu.
