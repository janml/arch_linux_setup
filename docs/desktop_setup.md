# Desktop setup
The following steps provide some information about my desktop environment.

### Install wayland and sway
````shell
pacman -S wayland xorg-xwayland sway swaybg swaylock wmenu waybar polkit alacritty noto-fonts
````

Copy the default sway config from `/etc/sway/config` to `~/.config/sway/config`.

### Desktop portal
Portals are the framework for securely accessing resources from outside an application sandbox.

````shell
pacman -S xdg-desktop-portal xdg-desktop-portal-wlr
````

### Audio support
````shell
pacman -S sof-firmware  # Optional firmware for onboard soundcards
pacman -S pipewire pipewire-audio pipewire-alsa pipewire-jack pipewire-pulse pavucontrol
````

### Themes
- Config-GUI `nwg-look`
- Theme `materia-gtk-theme`
- Icons `papirus-icon-theme` 
