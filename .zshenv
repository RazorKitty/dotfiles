if [ -r ~/.zprezto/runcoms/zenv ]; then
    source ./zprezto/runcoms/zenv
fi
#set sonme enviroment vars

export HOSTNAME=$(</etc/hostname)
export EDITOR=nvim
export VISUAL=nvim

xq () {
    xbps-query --regex -RS "$@" || xbps-query --regex -Rs "$@"
}

lscp () {
    scp "$@"; /bin/echo -e "\a"
}

alias sudo="sudo -E"
alias alert="/bin/echo -e "\a" && beep -l 100 -d 100 -r 2"
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "

