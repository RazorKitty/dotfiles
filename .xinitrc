#!/bin/zsh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

service() {
    pgrep -x "$1" || $@
}

optional_service() {
    which "$1" && service $@
}


# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

export $(dbus-launch)

## services
service xss-lock xlock &
service xbanish &
service start-pulseaudio-x11 &
service mpd --no-daemon &
service mpDris2 &
optional_service Discord --start-minimized &
optional_service steam -silent &
optional_service ckb-next -b &

xdg-settings set default-web-browser "qutebrowser.qutebrowser.desktop"
exec  awesome
