#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
nice -n -20 proot --link2symlink -0 -r ~/kali-lxc -b /dev -b /proc -b /sys -b /sdcard -w /root /usr/bin/env -i HOME=/root TERM=xterm-256color PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
