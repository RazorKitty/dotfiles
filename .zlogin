if [ -r ~/.zprezto/runcoms/zlogin ]; then
    source ~/.zprezto/runcoms/zlogin
fi

if [ -z $(pgrep -x "startx") ] && [ $(tty) != '/dev/pts/0' ]; then
    exec startx 
fi

