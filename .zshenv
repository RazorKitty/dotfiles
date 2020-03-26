if [ -r ~/.zprezto/runcoms/zenv ]; then
    source ./zprezto/runcoms/zenv
fi
#set sonme enviroment vars

export HOSTNAME=$(</etc/hostname)
export EDITOR=nvim
export VISUAL=nvim


clear () {
    /usr/bin/clear
    if [ -x /usr/bin/neofetch ]; then
        neofetch --gtk2 off --gtk3 off
    fi
}

ost () {
    if [[ -n $DISPLAY ]]; then
        st -e "$@" > /dev/null 2>&1 &
    fi
}


xq () {
    xbps-query --regex -RS "$@" || xbps-query --regex -Rs "$@"
}

lscp () {
    scp "$@"; /bin/echo -e "\a"
}

alias night_mode="xbacklight -ctrl tpacpi::kbd_backlight -set 50  && xbacklight -ctrl intel_backlight -time 333 -fps 60 -set 1"
alias day_mode="xbacklight -ctrl tpacpi::kbd_backlight -set 0 && xbacklight -ctrl intel_backlight -time 333 -fps 60 -set 50"

alias sudo="sudo -E"
alias alert="/bin/echo -e "\a" && beep -l 100 -d 100 -r 2"
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "

