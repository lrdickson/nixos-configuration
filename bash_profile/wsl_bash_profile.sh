if [ -e /home/lyndsey/.nix-profile/etc/profile.d/nix.sh ]; then . /home/lyndsey/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export WSL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print$2}')
export DISPLAY=$WSL_HOST:0
