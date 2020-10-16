if [ -r ~/.zprezto/runcoms/zenv ]; then
    source ./zprezto/runcoms/zenv
fi
# set sonme enviroment vars

xq () {
    xbps-query --regex -RS $@ || xbps-query --regex -Rs $@;
}

lscp () {
    scp $@; /bin/echo -e "\a";
}

nvim () {
         if [ $# -eq '1' ] && [ -d "$1" ]; then
            (
                cd "$1";
                /bin/nvim;
            )
        else
            /bin/nvim $@;
        fi
}

alias sudo="sudo -E"
alias alert="/bin/echo -e "\a" && beep -l 100 -d 100 -r 2"

