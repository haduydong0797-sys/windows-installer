#!/bin/bash

set -e

IMG_URL="https://drive.google.com/uc?export=download&id=1KJJJ4FN4zins8s-F_c6Ndh98d004lZWS"

echo "=============================="
echo " Windows Auto Installer"
echo "=============================="

echo "Detecting disk..."

DISK=""

for d in /dev/vda /dev/sda /dev/nvme0n1
do
 if [ -b "$d" ]; then
  DISK=$d
  break
 fi
done

if [ -z "$DISK" ]; then
 echo "No disk found"
 exit 1
fi

echo "Disk detected: $DISK"
echo "Starting installation..."

apt update -y
apt install -y wget gzip

cd /root

echo "Downloading Windows image..."

wget -O windowsDO.gz $IMG_URL

echo "Writing image to disk..."

gunzip -c windowsDO | dd of=$DISK bs=4M status=progress

sync

echo "Installation complete"
echo "Rebooting..."

sleep 5
reboot
