export WSL_HOST=(cat /etc/resolv.conf | grep nameserver | awk '{print$2}')
export DISPLAY=$WSL_HOST:0
