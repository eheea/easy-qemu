# easy QEMU

== a script that makes installing QEMU/KVM easier.
note that this script dosent automate gpu passthru as thats a whole different thing.
this is a base install of all the tools you need to make windows and linux VM's.
check the yt list in the bottom to learn more about gpu passthru.


## how to use
#### for ubuntu/debian users
1. make sure git is installed on your system. you can use `sudo apt install git` to get it if not already installed.
2. in terminal type `git clone https://github.com/eheea/easy-qemu && cd easy-qemu/ubuntu/ && chmod +x ./* && ./qemu.sh`.



### for fedora/arch users
1. make sure git is installed on your system using `sudo pacman -S git` for arch and `sudo dnf in git` for fedora
2. in terminal type `git clone https://github.com/eheea/easy-qemu && cd easy-qemu/fedora.arch/ && ./qemu.sh`
3. after the system restarts open up a terminal and run this command `cd easy-qemu/fedora.arch/ && ./post-restart.sh`.


* all credit goes to sysguides https://www.youtube.com/@SysGuides as this code is a simplified version of his video.
- the video https://www.youtube.com/watch?v=LHJhFW7_8EI.

== some useful sources
- installing a windows 11 VM https://www.youtube.com/watch?v=7tqKBy9r9b4
- gpu passthru tutorials https://www.youtube.com/playlist?list=PLr4VzN47_-HKmHrXBmygMsE6FSVF0j4FV
