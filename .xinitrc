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
xset -dpms &
pulseaudio --log-target=syslog &
mpd --no-daemon &
xbanish &
xss-lock 'xlock' &
which ckb-next && ckb-next --background &
which radeon-profile && radeon-profile &


exec dbus-launch --exit-with-session awesome $@
