#############################
Managing Software Packages
#############################

Open Source software packages are maintained in repositories. Each release has 
a version number, and package dependencies are recorded so that matching 
versions of packages can be installed together. Occasionally software updates 
are not aligned perfectly, and an update to one program and its dependencies 
will break other installed programs.

This article explains how to manage installed and upgraded packages in an 
Ubuntu system using utility programs :program:`synaptic`, :program:`dpkg`, and 
:program:`apt-{anything}`.

.. hint:: 
   Display all the :program:`apt-` programs at the console by typing
   :kbd:`apt-<Tab><Tab>`.

General package rules
=============================

+  Only one package management program may be run at a time. Do not,say, start 
   :program:`synaptics` in a window and try to run an :program:`apt-` utility 
   in a console session at the same time.
+  Package programs require root privileges. Use :command:`sudo` to execute all 
   commands.
+  Wild-card expressions are permitted in version numbers. When using versions, 
   make sure the version expression uniquely selects the desired version from 
   available cached packages.

Package management utilities
=============================

synaptics
-----------------------------

Use the synaptics menu option :menuselection:`File --> History` to review 
package changes.

apt-get
-----------------------------

::

   sudo apt-get update && sudo apt-get upgrade
   sudo apt-get install {package}={version}
   sudo apt-get -f install

apt-cache
-----------------------------

::

   sudo apt-cache policy {package}
  
apt-mark
-----------------------------

::

   sudo apt-mark hold {package} --version {version}

apt-show-versions
-----------------------------

::

   apt-show-versions {package}

dpkg
-----------------------------

::

   sudo dpkg --configure -a

Special commands
=============================

Show all packages installed or upgraded in the past 3 days::

   find /var/lib/dpkg/info/ -name \*.list -mtime -3 | sed `s#.list$##; s#.*/##`

Place a package on hold using a pin file::

   sed -i 'Package: {program}\nPin: {version}\nPin-Priority: 1000' /etc/apt/preferences/{program/