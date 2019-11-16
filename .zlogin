if [ -r ~/.zprezto/runcoms/zlogin ]; then
    source ~/.zprezto/runcoms/zlogin
fi

if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P00d0015
  \e]P1ac1e33
  \e]P2247345
  \e]P3797724
  \e]P4174b58
  \e]P54d3a58
  \e]P6376e57
  \e]P748737a
  \e]P80f192e
  \e]P9de263e
  \e]PA33a667
  \e]PBabab30
  \e]PC20778c
  \e]PD77578c
  \e]PE50a178
  \e]PFb4c1c2
  "
  # get rid of artifacts
  clear
fi

if [ $TTY = "/dev/tty1" ]; then
    exec startx
fi

