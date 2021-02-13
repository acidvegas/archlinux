#!/bin/sh
set -xev

GIT_URL="https://raw.githubusercontent.com/acidvegas/archlinux/master"
RPI=0

systemctl stop sshd && systemctl disable sshd
passwd root
userdel -r alarm
useradd -m -s /bin/bash acidvegas && gpasswd -a acidvegas wheel && passwd acidvegas
timedatectl set-timezone America/New_York && timedatectl set-ntp true
echo "LANG=en_US.UTF-8" > /etc/locale.conf && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

setup_wifi() {
	echo "pi" > /etc/hostname
	echo -e "[Match]\nName=wlan0\n\n[Network]\nDHCP=ipv4\nMulticastDNS=yes\nAddress=10.0.0.100/24\nGateway=10.0.0.1" > /etc/systemd/network/25-wireless.network
	echo -e "[Resolve]\nDNS=8.8.4.4 8.8.8.8 2001:4860:4860::8888 2001:4860:4860::8844\nFallbackDNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001\nMulticastDNS=yes\nDNSSEC=no\nCache=yes" > /etc/systemd/resolved.conf
	ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
	wpa_passphrase MYSSID passphrase > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf && chmod 600 /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
	systemctl start systemd-networkd && systemctl enable systemd-networkd
	systemctl start systemd-resolved && systemctl enable systemd-resolved
	systemctl start wpa_supplicant@wlan0 && systemctl enable wpa_supplicant@wlan0
}

setup_pacman() {
	pacman-key --init && pacman-key --populate archlinuxarm
	echo 'Server = http://mirror.archlinuxarm.org/$arch/$repo' > /etc/pacman.d/mirrorlist
	pacman -Syy wget
	wget -O /etc/pacman.conf $GIT_URL/etc/pacman.conf
	if [ $RPI -eq 0 ]; then
		sed -i 's/^Architecture = auto/Architecture = armv6h/' /etc/pacman.conf
	elif [ $RPI -eq 4 ]; then
		sed -i 's/^Architecture = auto/Architecture = armv7h/' /etc/pacman.conf
	fi
	pacman -Syyu
	pacman -S gcc make patch pkg-config python python-pip
	pacman -S asciiquarium cmatrix
	pacman -S abduco exa git man ncdu pass-otp sudo tor weechat which
	pacman -S alsa-utils cmus id3v2 python-eyed3 youtube-dl
	pacman -S dmenu firefox unclutter xclip
	pacman -S xf86-video-fbdev xorg-xinit xorg-server xorg-xsetroot
}

setup_bash() {
	echo "clear && reset" > /etc/bash.bash_logout
	echo -e "export VISUAL=nano\nexport EDITOR=nano\nunset HISTFILE\nln /dev/null ~/.bash_history -sf" >> /etc/profile
	echo "[[ -f ~/.bashrc ]] && . ~/.bashrc" > /root/.bash_profile
	echo -e "[[ $- != *i* ]] && return\nalias diff='diff --color=auto'\nalias grep='grep --color=auto'\nalias ls='ls --color=auto'\nPS1='\e[1;31m> \e[0;33m\w \e[0;37m: '" > /root/.bashrc
	source /root/.bashrc
	history -c && export HISTFILESIZE=0 && export HISTSIZE=0 && unset HISTFILE
	[ -f /root/.bash_history ] && rm /root/.bash_history
}

setup_configs() {
	sed -i 's/^console=tty1/console=tty3/' /boot/cmdline.txt && echo "quiet loglevel=3 logo.nologo consoleblank=0" >> /boot/cmdline.txt
	if [ $RPI -eq 0 ]; then
		echo -e "gpu_mem=16\navoid_warnings=1\ndisable_splash=1\ndtparam=act_led_trigger=none\ndtparam=act_led_activelow=on\ndtoverlay=pi3-disable-bt\ndtparam=audio=off" > /boot/config.txt
	elif [ $RPI -eq 4 ]; then
		echo -e "avoid_warnings=1\ndisable_splash=1\ndtparam=act_led_trigger=none\ndtparam=act_led_activelow=on\ndtparam=audio=on" > /boot/config.txt
	fi
	wget -O /etc/dialogrc $GIT_URL/etc/dialogrc
	wget -O /etc/issue $GIT_URL/etc/issue
	wget -O /etc/fstab $GIT_URL/etc/fstab
	wget -O /etc/ssh/sshd_config $GIT_URL/etc/ssh/sshd_config
	wget -O /etc/sudoers.d/sudoers.lecture $GIT_URL/etc/sudoers.d/sudoers.lecture
	wget -O /etc/topdefaultrc $GIT_URL/etc/topdefaultrc
	echo -e "defaults.pcm.card 1\ndefaults.ctl.card 1" > /etc/asound.conf
	echo -e "set boldtext\nset morespace\nset nohelp\nset nonewlines\nset nowrap\nset quickblank\nset tabsize 4\nunbind ^J main\ninclude \"/usr/share/nano/*.nanorc\"" > /etc/nanorc
	echo -e "Defaults lecture = always\nDefaults lecture_file = /etc/sudoers.d/sudoers.lecture\nroot ALL=(ALL) ALL\n%wheel ALL=(ALL) ALL" > /etc/sudoers
	echo -e "[Journal]\nStorage=volatile\nSplitMode=none\nRuntimeMaxUse=500K" > /etc/systemd/journald.conf
	mkdir -p /etc/systemd/system/systemd-logind.service.d && echo -e "[Service]\nSupplementaryGroups=proc" > /etc/systemd/system/systemd-logind.service.d/hidepid.conf
	echo "FONT=ohsnap6x11r" > /etc/vconsole.conf
}

setup_wifi
setup_pacman
setup_bash
setup_configs