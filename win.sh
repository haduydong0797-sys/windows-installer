
#!/bin/bash

IMG_URL="https://dl.dropboxusercontent.com/scl/fi/h884mlecqxmjj03ghnj2d/disk.img.gz?rlkey=zcdmi7x7zr0j259af7wfm7sa9"

echo "=============================="
echo " Windows IMG Installer"
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

echo
read -p "All data will be erased. Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
 exit
fi

apt update -y
apt install -y wget gzip

cd /root

echo "Downloading Windows image..."

wget -O windows.img.gz $IMG_URL

echo "Writing image..."

gunzip -c windows.img.gz | dd of=$DISK bs=4M status=progress

sync

echo "Done. Rebooting..."

sleep 5
reboot
