#!/bin/sh
set -xev
[ ! -n $(pacman -Qs dosfstools) ] && pacman -S –-noconfirm dosfstools
echo -e "o\nn\np\n1\n\n+100M\nt\nc\nn\np\n2\n\n\nw\n" | fdisk -w always -W always /dev/sda
mkdir boot root
mkfs.vfat /dev/sda1 && mount /dev/sda1 boot
mkfs.ext4 /dev/sda2 && mount /dev/sda2 root
wget -O archlinuxarm.tar.gz http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
bsdtar -xpf archlinuxarm.tar.gz -C root && sync
mv root/boot/* boot
wpa_passphrase MYSSID passphrase > boot/wpa_supplicant.conf
umount boot root && rm -r archlinuxarm.tar.gz boot root