#!/bin/bash
clear
echo "your system will reboot after this script. make sure to close and save everything you have running"
echo "after rebooting run the post-restart.sh script to complete the install"
echo "do you wish to continue"
echo "1-yes"
echo "2-no"
read -r num
case $num in
1)


#installing packages for arch
if [ -f /usr/bin/pacman ]; then
echo "checking if AUR helpers exists"
if [ ! -f /usr/bin/yay ]; then
sudo pacman -Sy --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
else echo "AUR helper already exists"
fi
sudo pacman -Sy qemu-full libvirt virt-install virt-manager virt-viewer \
    edk2-ovmf swtpm qemu-img guestfs-tools libosinfo wget dnsmasq --noconfirm
yay -S tuned --noconfirm



for drv in qemu interface network nodedev nwfilter secret storage; do \
    sudo systemctl enable virt${drv}d.service; \
    sudo systemctl enable virt${drv}d{,-ro,-admin}.socket; \
  done
fi

#installing packages for fedora
if [ -f /usr/bin/dnf ]; then
sudo dnf install qemu-kvm libvirt virt-install virt-manager virt-viewer \
    edk2-ovmf swtpm qemu-img guestfs-tools libosinfo tuned wget -y
sudo dnf group install --with-optional virtualization -y

for drv in qemu interface network nodedev nwfilter secret storage; do \
    sudo systemctl enable virt${drv}d.service; \
    sudo systemctl enable virt${drv}d{,-ro,-admin}.socket; \
  done
fi

#installing packages for debian
if [ -f /usr/bin/apt ]; then
sudo apt install qemu-system-x86 libvirt-daemon-system virtinst \
    virt-manager virt-viewer ovmf swtpm qemu-utils guestfs-tools \
    libosinfo-bin tuned wget -y

sudo systemctl enable libvirtd.service
 fi

#installing virtio image
if [ ! -f /var/lib/libvirt/images ]; then 
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso
sudo mv virtio-win-* /var/lib/libvirt/images
else echo "virtio image already exists"
fi

#configuring tuneD
sudo systemctl enable --now tuned
sudo tuned-adm profile virtual-host
sudo tuned-adm verify

echo -e "\e[33msystem will reboot now\e[0m"
sleep 2
reboot
;;
2) echo "have a nice day i guess"
exit 0 ;;
*) echo "you didnt enter a proper number" ;;
esac