if [ -r ~/.zprezto/runcoms/zenv ]; then
    source ./zprezto/runcoms/zenv
fi
#set sonme enviroment vars

xq () {
    xbps-query --regex -RS "$@" || xbps-query --regex -Rs "$@"
}

lscp () {
    scp "$@"; /bin/echo -e "\a"
}

dotfiles() {
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

dotfiles_add_all() {
    # Get all changed files, and stage them for commit
    dotfiles status | awk -v HOME=$HOME -e '/modified/{print HOME"/"$2}' | xargs -I {} dotfiles add {}
}

alias sudo="sudo -E"
alias alert="/bin/echo -e "\a" && beep -l 100 -d 100 -r 2"

