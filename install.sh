#!/bin/sh

sed -e 's/CheckSpace/#CheckSpace/' -e 's/#ParallelDownloads\ =\ 5/ParallelDownloads = 10\nILoveCandy/' -e 's/#Color/Color/' -e 's/#VerbosePkgLists/VerbosePkgLists/' -i /etc/pacman.conf

timedatectl set-ntp true

lsblk
printf "Enter the drive you have just partitioned for boot (just the name, ex: sda1) : " && read bootDrive
printf "Enter the big CHONKY partition (just the name, ex: sda3 ) : " && read linuxDrive
mkfs.vfat -F32 /dev/$bootDrive
mkfs.ext4 /dev/$linuxDrive

mount /dev/$linuxDrive /mnt

echo "Installing the base packages"
pacstrap /mnt base linux linux-firmware

echo "Generating the filesystem table"
genfstab -U /mnt >>/mnt/etc/fstab

echo "Enabling parallel downloads"
sed -e 's/CheckSpace/#CheckSpace/' -e 's/#ParallelDownloads\ =\ 5/ParallelDownloads = 10\nILoveCandy/' -e 's/#Color/Color/' -e 's/#VerbosePkgLists/VerbosePkgLists/' -i /mnt/etc/pacman.conf

mv ./post /mnt/root/post
mv ./postpost /mnt/root/postpost

echo "Chrooting into /mnt"
echo "run 'cd && ./post'"
chmod +x /mnt/root/post
chmod +x /mnt/root/postpost
arch-chroot /mnt
