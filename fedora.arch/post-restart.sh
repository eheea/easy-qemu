#!/bin/bash
#giving the user permissions to use KVM/QEMU
sudo usermod -aG libvirt "$USER"
echo "user was added to libvirt group"
echo "export LIBVIRT_DEFAULT_URI='qemu:///system'" >> ~/.bashrc
source ~/.bashrc

#giving permissions on the default directory
sudo setfacl -R -b /var/lib/libvirt/images
sudo setfacl -R -m u:"$USER":rwX /var/lib/libvirt/images
sudo setfacl -m d:u:"$USER":rwx /var/lib/libvirt/images

#setting up default network
sudo virsh net-start default
sudo virsh net-autostart default
echo "                       "
echo -e "\e[32mQEMU was successfully installed\e[0m"