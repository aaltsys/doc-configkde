#! /bin/bash
# Install 

echo "Install TeX, LaTeX, and ReStructured Text documentation tools"

if [[ $EUID -ne 0 ]] ; then echo -e "\e[1;31m try again using sudo \e[0m" ; exit 1 ; fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!! apt-install Routine !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#===== function to install a delimited package list ===========================

apt-pkgs() {

  # Install or purge packages listed in variable PKGS
  APT=0
  for i in $PKGS
  do
    dpkg -s $i > null
    if [ $OPER = 'install' ] ; then
      if [ $? -ne 0 ] ; then
        APT=1
        echo "$i is missing, it will be $OPERed"
        apt-get -y $OPER $i
      fi
    elif [ $OPER = 'purge' ] ; then
      if [ $? -eq 0 ] ; then
        APT=1
        echo "$i is installed, it will be $OPERd"
        apt-get -y $OPER $i
      fi
    fi
  done
   
  # verify installation and update packages indexes
  if [ $APT -ne 0 ] 
  then
    echo -e  "\e[1;31m Updating system packages, this may take a while \e[0m"
    apt-get -y -f install && apt-get -y update 
  fi

}

# !!!!!!!!!!!!!!!!!!!!!!!!!!! Main Program !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
===============================================================================

# install python and TeX tools
OPER='install'
PKGS='python-setuptools python-dev python-numpy python-qt4 python-qt4-gl python-vtk'
PKGS+=' build-essential texlive-full'
apt-pkgs

# install sphinx-tools
OPER='purge'
PKGS='python-configobj python-docutils python-pygments python-sphinx rst2pdf'
apt-pkgs
easy_install configobj docutils pygments sphinx rst2pdf 

exit 0