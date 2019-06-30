if [ -r ~/.zprezto/runcoms/zshrc ]; then
    source ~/.zprezto/runcoms/zshrc
fi
#
#if [[ -x /bin/tmux && -v DISPLAY && ! -v TMUX ]]; then
#    exec tmux
#fi
#
#if [[ -x /bin/neofetch ]]; then
#    neofetch
#fi
#
#if [[ -x /bin/task ]]; then
#    task list
#fi
if [[ -f "/tmp/${USER}/lock.sh.lock" ]]; then
    lock
fi
