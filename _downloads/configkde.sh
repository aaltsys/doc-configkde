#! /bin/bash

# update editor preferences (interactive)

sudo update-alternatives --config editor

# ssh configuration

if [ ! -f ~/.ssh/id_rsa ]; then ssh-keygen -N '' -f ~/.ssh/id_rsa; fi
sudo sed -ie "s/    HashKnown/#   HashKnown/" /etc/ssh/ssh_config
sudo sed -ie "/ForwardX11/c\    ForwardX11 yes" /etc/ssh/ssh_config

# dosemu installation and configuration

sudo aptitude install dosemu xauth
sudo sysctl -w vm.mmap_min_addr=0
sudo bash < <(echo 'echo "vm.mmap_min_addr=0" >> /etc/sysctl.conf')

# local configuration file
echo '$_X_font = vga12x30' >> ~/.dosemurc
echo '$_hogthreshold = (5)' >> ~/.dosemurc

# global change alternative ---
# sudo sed -ie "/$_X_font/c\$_X_font = vga12x30" /etc/dosemu/dosemu.conf