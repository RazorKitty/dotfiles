if [ -r ~/.zprezto/runcoms/zlogout ]; then
    source ./zprezto/runcoms/zlogout
fi

killall mpd  &
