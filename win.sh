#!/bin/bash

set -e

IMG_URL="https://dumgzwin.atl1.cdn.digitaloceanspaces.com/winDO111.gz"

echo "================================="
echo "     Windows VPS Installer"
echo "================================="

echo "Detecting disk..."

for d in /dev/vda /dev/sda /dev/nvme0n1
do
 if [ -b "$d" ]; then
  DISK=$d
  break
 fi
done

if [ -z "$DISK" ]; then
 echo "No disk found!"
 exit 1
fi

echo "Disk: $DISK"

echo "Installing required tools..."
apt update -y
apt install -y curl gzip

echo "Starting Windows installation..."

curl -L "$IMG_URL" | gunzip | dd of=$DISK bs=32M status=progress

echo ""
echo "================================="
echo " Windows image written to disk"
echo " Rebooting server..."
echo "================================="

sleep 2

echo b > /proc/sysrq-trigger
