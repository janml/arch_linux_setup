# Sway installation
I am using wayland because its more secure than Xorg and sway because its cool :)

Install wayland and sway

```shell
sudo pacman -S wayland xorg-xwayland polkit noto-fonts foot sway swaybg wmenu swaylock rofi
```

Copy the default sway config to the user sway config
```shell
mkdir ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
```

Set the keyboard layout by editing `~/.config/sway/config`
```shell
input * {
    xkb_layout "de"
}
```

Start sway on tty1 login, edit `~/.bash_profile` (if you use bash)
```shell
[ "$(tty)" = "/dev/tty1" ] && exec sway
```


For more configuration read the [sway docs](https://github.com/swaywm/sway/wiki)
