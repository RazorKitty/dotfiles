if [ -r ~/.zprezto/runcoms/zprofile ]; then
    source ~/.zprezto/runcoms/zprofile
fi
export PATH=$HOME/.bin:$HOME/.cargo/bin:$PATH
export HOSTNAME=$(</etc/hostname)
export EDITOR=nvim
export VISUAL=nvim

