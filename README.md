# easy QEMU

== description
a script that makes installing QEMU/KVM easier.


== how to use
#### for ubuntu/debian users
1. make sure git is installed on your system. you can use `sudo apt install git` to get it if not already installed.
2. in terminal type `git clone https://github.com/eheea/easy-qemu && cd easy-qemu/ubuntu/ && chmod +x ./* && ./qemu.sh`.



### for fedora/arch users
1. make sure git is installed on your system using `sudo pacman -S git` for arch and `sudo dnf in git` for fedora
2. in terminal type `git clone https://github.com/eheea/easy-qemu && cd easy-qemu/fedora.arch/ && ./qemu.sh`
3. after the system restarts run this command `cd easy-qemu/fedora.arch/ && ./post-restart.sh`


-------------------------------------------------------------------
* im open to suggestions as to how to avoid restarting on fedora and arch.