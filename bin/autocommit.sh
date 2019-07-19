#!/bin/sh


git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add $1
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m "$(date)"
