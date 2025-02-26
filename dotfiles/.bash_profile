#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start sway on tty login
[ "$(tty)" = "/dev/tty1" ] && exec sway
