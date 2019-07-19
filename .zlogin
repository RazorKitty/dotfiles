if [ -r ~/.zprezto/runcoms/zlogin ]; then
    source ~/.zprezto/runcoms/zlogin
fi

if [[ -z $(pgrep -x "entr") ]]; then
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree -r master --name-only | entr -p $HOME/bin/autocommit.sh /_ &
fi

if [ -z $(pgrep -x "startx") ] && [ $(tty) != '/dev/pts/0' ]; then
    exec startx 
fi

