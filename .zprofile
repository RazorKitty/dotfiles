if [ -r ~/.zprezto/runcoms/zprofile ]; then
    source ~/.zprezto/runcoms/zprofile
fi

export PATH="$HOME/.bin:$HOME/.cargo/bin:$HOME.symfony/bin:$PATH"
export HOSTNAME="$(</etc/hostname)"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_ASKPASS="$HOME/.bin/askpass"
export LUA_PATH="$HOME/.local/share/lua/?.lua;$HOME/.local/share/lua/?/init.lua;;"
