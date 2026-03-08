#!/bin/bash

set -e

IMG_URL="https://dumgzwin.atl1.cdn.digitaloceanspaces.com/winD01.gz"

echo "================================="
echo "   Windows VPS Auto Installer"
echo "================================="

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
 echo "❌ No disk found"
 exit 1
fi

echo "Disk detected: $DISK"

echo "Installing required tools..."

apt update -y
apt install -y aria2 gzip

echo "Starting Windows installation..."

aria2c -x16 -s16 -k1M -o - "$IMG_URL" | gunzip | dd of=$DISK bs=16M oflag=direct status=progress

sync

echo ""
echo "================================="
echo " Windows installation completed"
echo " Server will reboot in 5 seconds"
echo "================================="

sleep 5
reboot
