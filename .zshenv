if [ -r ~/.zprezto/runcoms/zenv ]; then
    source ./zprezto/runcoms/zenv
fi
#set sonme enviroment vars
export SUDO_ASKPASS=~/.scripts/sudo_ask_pass.zsh
export HOSTNAME=$(</etc/hostname)

zsh-update () {
    if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
        echo "Updating zprezto..."
        git -C "${ZDOTDIR:-$HOME}/.zprezto" pull --recurse-submodules
        echo "Done"
    else
        echo "Zprezto not found installing..."
        git clone https://github.com/sorin-ionedcu/prezto .zprezto
        echo "Done"
    fi
}

clear () {
    /usr/bin/clear
    if [ -x /usr/bin/neofetch ]; then
        neofetch
    fi
    if [ -x /usr/bin/task ]; then
        task next
    fi
}

ost () {
    if [[ -n $DISPLAY ]]; then
        st -e "$@" > /dev/null 2>&1 &
    fi
}

xi () {
    sudo xbps-install "$@"; echo -e "\a"
}

xq () {
    xbps-query -RS "$@" || xbps-query -Rs "$@"
}

alias night_mode="xbacklight -ctrl tpacpi::kbd_backlight -set 50  && xbacklight -ctrl intel_backlight -time 333 -fps 60 -set 1"
alias day_mode="xbacklight -ctrl tpacpi::kbd_backlight -set 0 && xbacklight -ctrl intel_backlight -time 333 -fps 60 -set 50"

alias mc=". /usr/libexec/mc/mc-wrapper.sh"
alias sudo="sudo -E"
alias alert="beep -l 100 -d 100 -r 2"