#!/bin/bash
#checking virtulization support
lscpu | grep Virtualization > .support.txt
if ! grep -q -i AMD-V .support.txt || grep -q -i VT-x .support.txt ; then
echo "Virtulization support it turned off in the bios settings (mainly VT-D,VT-X for intel cpus and SVM for AMD cpus ). turn it on and try again"
exit 2
else 
echo "virtulization is supported."
fi

#installing packages
sudo apt install qemu-system-x86 libvirt-daemon-system virtinst \
    virt-manager virt-viewer ovmf swtpm qemu-utils guestfs-tools \
    libosinfo-bin tuned wget -y

sudo systemctl enable libvirtd.service


#downloading virtio image
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso
sudo mv virtio-win-* /var/lib/libvirt/images

#enabling tuneD
sudo systemctl enable --now tuned
sudo tuned-adm profile virtual-host
sudo tuned-adm verify

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
echo -e "\e[32mit is recommened to reboot, reboot now?\e[0m"
echo "1) yes"
echo "2) no"
read -r reboot
case $reboot in
1) reboot ;;
2) echo "QEMU was successfully installed" ;;
esac
