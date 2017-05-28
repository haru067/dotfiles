#!/usr/bin/env bash
set -euo pipefail

dst="$HOME/dotfiles"

if [ ! -e $dst/.git ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/haru067/dotfiles $dst
else
    echo "Updating dotfiles..."
    (cd $dst && git pull)
fi

echo "Creating symbolic links..."
ln -si $dst/src/.gitconfig $HOME/.gitconfig
ln -si $dst/src/.zshrc $HOME/.zshrc
if [ "$(uname)" == 'Darwin' ]; then
    #mac
    ln -si $dst/src/.vimrc $HOME/_vimrc
    ln -si $dst/src/.gvimrc $HOME/_gvimrc
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    #linux
    :
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    #cygwin
    :
else
    echo "($(uname -a)) is not supported."
    exit 1
fi
