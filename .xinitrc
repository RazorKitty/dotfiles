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

start-pulseaudio-x11 &


if [ -z $(pgrep -x "mpd") ]; then
    mpd  &
fi

if [ -z $(pgrep -x "xbanish") ]; then
    xbanish  &
fi

if [ -z $(pgrep -x "ckb-next") ] && [ cat /dev/input/ckb0/connected |  grep -q '[^[:space:]]]' ]; then
    ckb-next --background &
fi

if [ -z $(pgrep -x "kdeconnectd") ]; then
    /usr/lib/libexec/kdeconnectd &
fi

exec awesome
