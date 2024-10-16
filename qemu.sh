#!/bin/bash
echo "welcome to easy qemu script"
echo -e "\033[0;32mdo you want 'virtio-win' image (very important to set up windows virtual machines)\033[0m"
echo "        "
echo "*if you already have it you can select no"
echo "          "
echo "*if youre not sure what to do select yes"
echo "                       "
echo "1-yes"
echo "2-no"
read -r answer0
case $answer0 in
1) if [ -f /usr/bin/pacman ]; then
sudo pacman -S wget --noconfirm
fi

if [ -f /usr/bin/dnf ]; then
sudo dnf in wget -y
fi

if [ -f /usr/bin/apt ]; then
sudo apt install wget -y
fi

wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso

#checking virtulization support
lscpu | grep Virtualization > .support.txt
if ! grep -q -i AMD-V .support.txt || grep -q -i VT-x .support.txt ; then
echo "Virtulization support it turned off in the bios settings. turn it on and try again"
exit 2
else 
echo "virtulization is supported."
fi

#installing packages for arch
if [ -f /usr/bin/pacman ]; then
echo "checking if AUR helpers exists"
if [ ! -f /usr/bin/yay ]; then
sudo pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
else echo "AUR helper already exists"
fi
sudo pacman -S qemu-full libvirt virt-install virt-manager virt-viewer \
    edk2-ovmf swtpm qemu-img guestfs-tools libosinfo wget dnsmasq --noconfirm
yay -S tuned --noconfirm

sudo mv virtio-win-* /var/lib/libvirt/images

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

mv virtio-win-* /var/lib/libvirt/images

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

mv virtio-win-* /var/lib/libvirt/images

sudo systemctl enable libvirtd.service
 fi

#configuring tuneD
sudo systemctl enable --now tuned
sudo tuned-adm profile virtual-host
sudo tuned-adm verify

#giving the user permissions to use KVM/QEMU
if [ -f /usr/bin/pacman ]; then
virsh uri
sudo virsh uri
systemctl start virtqemud.socket
fi

if [ -f /usr/bin/dnf ]; then
virsh uri
sudo virsh uri
systemctl start virtqemud.socket
fi

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


echo "         "
echo -e "\033[0;32mit is recommened that you reboot your pc. do you want to do it now?\033[0m"
echo "1-reboot now"
echo "2-reboot later"
read -r answer
case $answer in
1) reboot ;;
2) echo -e "\033[0;32mKVM/QEMU was successfully installed. please reboot when possible\033[0m" ;;
esac
;;



2) 
#checking virtulization support
lscpu | grep Virtualization > .support.txt
if ! grep -q -i AMD-V .support.txt || grep -q -i VT-x .support.txt ; then
echo "Virtulization support it turned off in the bios settings. turn it on and try again"
exit 2
else 
echo "virtulization is supported."
fi

#installing packages for arch
if [ -f /usr/bin/pacman ]; then
echo "checking if AUR helpers exists"
if [ ! -f /usr/bin/yay ]; then
sudo pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
else echo "AUR helper already exists"
fi
sudo pacman -S qemu-full libvirt virt-install virt-manager virt-viewer \
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

mv virtio-win-* /var/lib/libvirt/images

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

#configuring tuneD
sudo systemctl enable --now tuned
sudo tuned-adm profile virtual-host
sudo tuned-adm verify

#giving the user permissions to use KVM/QEMU
if [ -f /usr/bin/pacman ]; then
virsh uri
sudo virsh uri
systemctl start virtqemud.socket
fi

if [ -f /usr/bin/dnf ]; then
virsh uri
sudo virsh uri
systemctl start virtqemud.socket
fi


sudo usermod -aG libvirt "$USER"
echo "export LIBVIRT_DEFAULT_URI='qemu:///system'" >> ~/.bashrc
source ~/.bashrc

#giving permissions on the default directory
sudo setfacl -R -b /var/lib/libvirt/images
sudo setfacl -R -m u:"$USER":rwX /var/lib/libvirt/images
sudo setfacl -m d:u:"$USER":rwx /var/lib/libvirt/images

#setting up default network
sudo virsh net-start default
sudo virsh net-autostart default

echo "         "
echo -e "\033[0;32mit is recommened that you reboot your pc. do you want to do it now?\033[0m"
echo "1-reboot now"
echo "2-reboot later"
read -r answer
case $answer in
1) reboot ;;
2) echo -e "\033[0;32mKVM/QEMU was successfully installed. please reboot when possible\033[0m" ;;
esac

;;
*) echo "you didnt enter an appropriate option. please try again"
exit 3
esac