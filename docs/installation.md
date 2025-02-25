# Installation

The following steps install a basic Arch Linux system.

## Pre-installation steps
Change the default keyboard layout
```shell
loadkeys de
```

Establish an internet connection (wifi only)
```shell
iwctl

# inside of iwctl
device list    
station <wifi-device> connect "<wifi-ssid>"
```

## Create partitions
I am using the following partition scheme:
- `FAT32 EFI Boot`
- `Ext4 Root`

List disks `lsblk` (list block devices).
Open with `gdisk /dev/<block-device>`.
Inside of gdisk:

```shell
# First the boot partition:
Command: n
Partition number: 1
First sector: Enter
Last sector: +512M
Hex code: ef00

# Second the root parition:
Command: n
Partition number: 2
First sector: Enter
Last sector: Enter
Hex code: 8300

Command: w
```

## Encrypt the root partition
```shell
cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/<root-partition>
```

Open the encrypted partition, so we can work with it.
```shell
crytsetup luksOpen /dev/<encrypted-root-partition> cryptroot
```

## Create the filesystems
```shell
mkfs.fat -F32 -n UEFI /dev/<boot-partition>
mkfs.ext4 -L root /dev/mapper/cryptroot
```

Mount the partitions
```shell
mount /dev/mapper/cryptroot /mnt
mount --mkdir /dev/<boot-partition> /mnt/boot
```

## Install the base system
```shell
pacstrap /mnt linux linux-firmware base base-devel dosfstools dhcpcd vim sudo
```

## Configure the base system
Generate the file system table
```shell
genfstab -Lp /mnt > /mnt/etc/fstab
```

Change-root into the newly installed system
```shell
arch-chroot /mnt
```

Set the hostname
```shell
echo <hostname> > /etc/hostname
```

Configure local DNS, edit `/etc/hosts`
```shell
127.0.0.1 localhost
::1       localhost
127.0.1.1 <hostname>.localdomain <hostname>
```

Set the systems locale
```shell
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
```

Set the keyboard layout
```shell
echo "KEYMAP=de-latin1" > /etc/vconsole.conf
```

Set the timezone
```shell
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
```

Tell the system which modules to load durint the boot phase, edit `/etc/mkinitcpio.conf`
```shell
MODULES = (ext4)
HOOKS=(base udev autodetect modconf block keyboard keymap encrypt filesystems fsck shutdown)
```

Recreate the kernel image
```shell
mkinitcpio -p linux
```

## Setup the boot loader
I am using systemd boot (Gummiboot)

Install the boot loader on the boot partition
```shell
bootctl --path=/boot install
```

Create a new boot loader entry at `/boot/loader/entries/arch.conf`
```
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  cryptdevice=/dev/<root-partition>:cryptroot root=/dev/mapper/cryptroot rw lang=en init=/usr/lib/systemd/systemd locale=en_US.UTF-8
```

Tell the boot loader to use the previously created entry, edit `/boot/loader/loader.conf`
```shell
timeout 3
default arch.conf
```


## Install Network manager
Install
```shell
pacman -S networkmanager
```
Enable the systemd service
```shell
systemctl enable NetworkManager
```

## Install graphics card driver 
Check your vendor with `lspci | grep VGA`

Install the proper driver for your vendor:

- For AMD: `xf86-video-amdgpu`
- For Intel: `xf86-video-intel`
- For Nvidia: `nvidia-open`

## Install sound drivers
```shell
pacman -S sof-firmware pulseaudio-alsa pulseaudio-jack pulseaudio-bluetooth jack2
```


## Setup users
First change the root password
```shell
passwd
```

Add a non-root user
```shell
useradd -m -G users,wheel <username>
passwd <username>
```

Allow the users of group `wheel` to run sudo commands
```shell
sudo EDITOR=vim visudo

# uncomment
%wheel% ALL=(ALL:ALL) ALL
```


## Reboot
```shell
exit
umount -a
reboot
```
After reboot login with your user.


## Establish an internet connection (wifi only)
When rebooting after the base installation the network config is lost.
We can establish a new wireless internet connection with `nmcli`:
```shell
nmcli device wifi connect '<wifi-ssid>' --ask
```

## Create homefolder sub-directories
Install tool to generate sub-directories
```shell
sudo pacman -S xdg-user-dirs
```

And create the directories:
```shell
xdg-user-dirs-update
```
