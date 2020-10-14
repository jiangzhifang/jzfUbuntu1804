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

HD_TYPE=$(megacli -PdList -aAll -NoLog | grep "^Media Type" | head -n 1 | awk -F ': ' '{print $2}')

if [ "$HD_TYPE" == "Hard Disk Device" ]; then
    sed -i '/exit 0/i\echo "deadline" > /sys/block/sda/queue/scheduler' /etc/rc.local
elif [ "$HD_TYPE" == "Solid State Device" ]; then
    sed -i '/exit 0/i\echo "noop" > /sys/block/sda/queue/scheduler' /etc/rc.local
else
    echo "set io scheduler ERROR, check /etc/rc.local and /sys/block/sda/queue/scheduler" > /root/jzfUbuntu1804/jzf/set_io_scheduler.log
fi

sed -i '/exit 0/i\echo "2048" > /sys/block/sda/queue/nr_requests' /etc/rc.local
sed -i 's/TimeoutStartSec=5min/TimeoutStartSec=1sec/' /etc/systemd/system/network-online.target.wants/networking.service
