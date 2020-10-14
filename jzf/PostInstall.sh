#!/bin/bash
#
# File name: PostInstall.sh
#

cp /root/jzfUbuntu1804/jzf/tbclimits.conf /etc/security/limits.d/
cp /root/jzfUbuntu1804/jzf/99-tbcsysctl.conf /etc/sysctl.d/
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp /root/jzfUbuntu1804/jzf/sources.list /etc/apt/
sudo apt-get update 
sudo apt install gnupg -y
sudo wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install megacli

umount /TMP

TMP_PART_UUID=$(grep '/TMP' /etc/fstab | grep -v '#' | awk '{print $1}' | awk -F '=' '{print $2}')
TMP_PART_NUM=$(blkid | grep ${TMP_PART_UUID} | awk -F ':' '{print $1}' | awk -F 'sda' '{print $2}')
parted -s /dev/sda rm ${TMP_PART_NUM}

sed -i '\/TMP/d' /etc/fstab

cp /root/jzfUbuntu1804/jzf/rc.local /etc/
chmod +x /etc/rc.local
