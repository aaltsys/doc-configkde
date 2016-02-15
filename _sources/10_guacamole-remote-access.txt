.. _guacamole:

#############################
Guacamole Remote Access
#############################

Guacamole is a clientless remote desktop gateway, installable on Linux systems,
which connects a local workstation to remote desktops using an HTML5 browser.

Guacamole supports standard protocols like SSH, VNC, and RDP to access remote 
desktops. Thanks to HTML5, no plugins or client software are required at the 
remote systems. Both server and client packages are installed on the local 
accessing machine, and access is provided via a single web browser link.

Ubuntu configuration 
=============================

Guacamole is not yet packaged properly for Ubuntu, and so dependencies must be 
met by a script. The following instructions were sourced from a 
`TecMint Script <http://www.tecmint.com/guacamole-access-remote-linux-windows-machines-via-web-browser/>`_.

Guacamole Server & Client
-----------------------------

Download the Guacamole installation script:

   :download:`_downloads/guacamole-server.sh` 
   
Then run it from the console with the command:

   :command:`sudo bash ./guacamole-server.sh`

Configuring Guacamole
-----------------------------

Download the Guacamole configuration script:

   :download:`_downloads/guacamole-configure.sh` 
   
Then run it from the console with the command:

   :command:`sudo bash ./guacamole-configure.sh`
