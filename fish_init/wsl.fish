if test -e /home/lyndsey/.nix-profile/etc/profile.d/nix.sh
	. /home/lyndsey/.nix-profile/etc/profile.d/nix.sh
end

export WSL_HOST='(cat /etc/resolv.conf | grep nameserver | awk '{print$2}')'
export DISPLAY=$WSL_HOST:0
