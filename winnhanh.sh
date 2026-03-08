#!/bin/bash

set -e

IMG_URL="https://dumgzwin.atl1.cdn.digitaloceanspaces.com/hidemium.gz"

echo "================================="
echo "   Windows VPS Fast Installer"
echo "================================="

echo "Detecting disk..."

for d in /dev/vda /dev/sda /dev/nvme0n1
do
 if [ -b "$d" ]; then
  DISK=$d
  break
 fi
done

echo "Disk detected: $DISK"

apt update -y
apt install -y curl gzip

echo "Installing Windows..."

curl -L "$IMG_URL" | gunzip | dd of=$DISK bs=32M status=progress

echo "Windows written to disk."

echo "Rebooting..."

reboot -f
