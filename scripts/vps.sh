#!/bin/sh
set -xev
GIT_URL="https://raw.githubusercontent.com/acidvegas/archlinux/master"
passwd root
userdel -r alarm
useradd -m -s /bin/bash acidvegas && gpasswd -a acidvegas wheel && passwd acidvegas
timedatectl set-timezone America/New_York && timedatectl set-ntp true
echo "LANG=en_US.UTF-8" > /etc/locale.conf && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
pacman-key --init && pacman-key --populate archlinux
pacman -Syyu
pacman -S gcc make patch pkg-config python python-pip
pacman -S abduco exa git man ncdu sudo tor weechat which
echo "clear && reset" > /etc/bash.bash_logout
echo -e "export VISUAL=nano\nexport EDITOR=nano\nunset HISTFILE\nln /dev/null ~/.bash_history -sf" >> /etc/profile
echo "[[ -f ~/.bashrc ]] && . ~/.bashrc" > /root/.bash_profile
echo -e "[[ $- != *i* ]] && return\nalias diff='diff --color=auto'\nalias grep='grep --color=auto'\nalias ls='ls --color=auto'\nPS1='\e[1;31m> \e[0;33m\w \e[0;37m: '" > /root/.bashrc
source /root/.bashrc
history -c && export HISTFILESIZE=0 && export HISTSIZE=0 && unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
wget -O /etc/ssh/sshd_config $GIT_URL/etc/ssh/sshd_config
wget -O /etc/sudoers.d/sudoers.lecture $GIT_URL/etc/sudoers.d/sudoers.lecture
wget -O /etc/topdefaultrc $GIT_URL/etc/topdefaultrc
echo -e "set boldtext\nset markmatch\nset minibar\nset morespace\nset nohelp\nset nonewlines\nset nowrap\nset quickblank\nset tabsize 4\nunbind ^J main\ninclude \"/usr/share/nano/*.nanorc\"" > /etc/nanorc
echo -e "Defaults lecture = always\nDefaults lecture_file = /etc/sudoers.d/sudoers.lecture\nroot ALL=(ALL) ALL\n%wheel ALL=(ALL) ALL" > /etc/sudoers
echo -e "[Journal]\nStorage=volatile\nSplitMode=none\nRuntimeMaxUse=500K" > /etc/systemd/journald.conf