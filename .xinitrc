#!/bin/zsh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

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

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

if [ -z $(pgrep -x "pulseaudio") ]; then
    start-pulseaudio-x11 &
fi

if [ -z $(pgrep -x "mpd") ]; then
    mpd > /dev/null &
fi

if [ -z $(pgrep -x "xbanish") ]; then
    xbanish > /dev/null &
fi

if [ -z $(pgrep -x "ckb-next") ] && [ grep -q '[^[:space:]]]' < /dev/input/ckb0/connected ]; then
    ckb-next --background &
fi

if [ -z $(pgrep -x "kdeconnectd") ]; then
    /usr/lib/libexec/kdeconnectd &
fi

if [ -z $(pgrep -x "xcompmgr") ]; then
    xcompmgr -f &
fi

exec awesome
