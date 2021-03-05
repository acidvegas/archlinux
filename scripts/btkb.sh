#!/bin/sh
pacman -S bluez bluez-utils
systemctl enable bluetooth && sudo systemctl start bluetooth
sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf
bluetoothctl power on # possible bluetoothctl -- <cmd>
bluetoothctl agent KeyboardOnly
bluetoothctl pairable on
bluetoothctl scan on
bluetoothctl pair CC:C5:0A:20:91:5B
bluetoothctl trust CC:C5:0A:20:91:5B
bluetoothctl connect CC:C5:0A:20:91:5B
bluetoothctl scan off