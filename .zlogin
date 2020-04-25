if [ -r ~/.zprezto/runcoms/zlogin ]; then
    source ~/.zprezto/runcoms/zlogin
fi

if [ $TTY = "/dev/tty1" ]; then
    exec startx
fi

