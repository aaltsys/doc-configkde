#!/bin/bash
# This script is targeted to KUbuntu 13 KDE or Debian 6 KDE derivatives.
# This desktop script installs general productivity apps.
# The default script interpreter is assumed to be bash.

# Not working lines with release of KUbuntu 13 are marked with !!
# Problem packages are: chrome, cinelerra, adobe-flashplugin, sun-java6

echo "Install packages for Kubuntu 13.10 or other Debian 6 KDE"

if [[ $EUID -ne 0 ]] ; then echo -e "\e[1;31m try again using sudo \e[0m" ; exit 1 ; fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!! apt-repository Routine !!!!!!!!!!!!!!!!!!!!!!!!!!
#===== function to add a delimited repository list ============================

apt-repos() {

  # Install repositories listed in variable REPOS
  APT=0
  for i in $REPOS
  do
    APT=1
    apt-add-repository $i
  done
   
  # verify installation and update packages indexes
  if [ $APT -ne 0 ] 
  then
    echo -e  "\e[1;31m Updating system repository indexes \e[0m"
    apt-get -y -f install && apt-get -y update 
  fi

}

# !!!!!!!!!!!!!!!!!!!!!!!!!!! apt-install Routine !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#===== function to install a delimited package list ===========================

apt-pkgs() {

  # Install packages listed in variable PKGS
  APT=0
  for i in $PKGS
  do
    dpkg -s $i > null
    if [ $? -ne 0 ] ; then
      APT=1
      echo "$i is missing, it will be installed"
      apt-get -y install $i
    fi
  done
   
  # verify installation and update packages indexes
  if [ $APT -ne 0 ] 
  then
    echo -e "\e[1;31m Updating system packages, this may take a while \e[0m"
    apt-get -y -f install && apt-get -y update 
  fi

}

# !!!!!!!!!!!!!!!!!!!!!!!!!!! Main Program !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
===============================================================================

# Add repositories, browsers
# ###########################

# universe/multiverse repositories
apt-add-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"

# add repositories for: Cinelerra, Ubuntu tweaks, Rails

REPOS='ppa:cinelerra-ppa/ppa ppa:tualatrix/ppa ppa:ubuntu-on-rails/ppa'
apt-repos

# upgrade Firefox, replace latex-xft-fonts with ttf-lyx, add curl for Chrome
PKGS='install curl firefox ttf-lyx ubufox'
apt-pkgs

# install Google Chrome stable
if [ "`uname -i`" = "i386" ] ; then
  CHROMEVER="google-chrome-stable_current_i386.deb"
else
  CHROMEVER="google-chrome-stable_current_amd64.deb"
fi
wget -O /tmp/chrome.deb https://dl-ssl.google.com/linux/direct/$CHROMEVER
dpkg -i /tmp/chrome.deb
rm /tmp/chrome.deb

# Install apps and tools
# ###########################

  # install desktop productivity apps
PKGS='blender cinelerra dia filezilla freemind gimp gnucash inkscape mypaint'
PKGS+=' openshot scribus shotwell skanlite xaralx'
apt-pkgs

# install desktop utility apps
PKGS='aptitude byobu cifs-utils diffuse dosbox dosemu'
PKGS+=' gdebi hplip-gui keepassx krdc kubuntu-restricted-extras lftp mc'
PKGS+=' nfs-common openvpn plasma-widget-lancelot playonlinux putty' 
PKGS+=' recordmydesktop screen ubuntu-tweak unison vlc wine wireshark xclip'
apt-pkgs

# install Sun (Oracle) java
PKGS='sun-java6-bin sun-java6-fonts sun-java6-javadb sun-java6-jdk'
PKGS+=' sun-java6-jre sun-java6-plugin'
apt-pkgs

# clean up aptitude at end
# ###########################

apt-get clean && apt-get update && apt-get upgrade

# Fix configuration problems
# ###########################

if [[ -z "$(grep 'vm.mmap_min_addr=0' /etc/modules)" ]] ; then 
   echo "vm.mmap_min_addr=0" >> /etc/modules
fi

# Restart system
# ###########################

reboot
