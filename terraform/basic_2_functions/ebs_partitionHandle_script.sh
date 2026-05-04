#!/bin/bash

ALLDISK=$(lsblk | grep -i disk | wc -l)
MYDISK=$(expr $ALLDISK - 1)
echo $MYDISK

NEWDISK=$(lsblk | grep -i disk | tail -$MYDISK | cut -d ' ' -f1)
echo $NEWDISK

for DISK in $NEWDISK; do
    df -h | grep -i $DISK
    if [ $? -eq 0 ]; then
        echo "Mount exists"
    else
        fdisk /dev/$DISK <<EOF
n
p


w
EOF
        mkdir /${DISK}p1
        mkfs.ext4 /dev/${DISK}p1
        mount /dev/${DISK}p1 /${DISK}p1
    fi
done