#!/usr/bin/env bash

set -e

IMG_URL="https://dumgzwin.atl1.cdn.digitaloceanspaces.com/winDO99.gz"

echo "================================="
echo "       Windows VPS Installer"
echo "================================="

echo "Detecting system disk..."

DISK=$(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print "/dev/"$1}' | head -n1)

if [ -z "$DISK" ]; then
    echo "No disk detected!"
    exit 1
fi

echo "Disk detected: $DISK"

echo "Installing required tools..."

if ! command -v curl >/dev/null; then
    apt-get update -y
    apt-get install -y curl gzip
fi

echo "---------------------------------"
echo "Downloading Windows image..."
echo "---------------------------------"

curl -L "$IMG_URL" | gunzip | dd of="$DISK" bs=16M status=progress oflag=direct

echo ""
echo "Flushing disk cache..."

sync

echo ""
echo "================================="
echo " Windows installation completed"
echo " System rebooting..."
echo "================================="

sleep 3

reboot
