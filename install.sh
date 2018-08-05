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
ln -si $dst/src/.gitconfig $HOME/.gitconfig || echo "skipped"
ln -si $dst/src/.gitattributes $HOME/.gitattrivutes || echo "skipped"
ln -si $dst/src/.zshrc $HOME/.zshrc || echo "skipped"
if [ "$(uname)" == 'Darwin' ]; then
    #mac
    vscode="$HOME/Library/Application Support/Code/User"
    ln -si $dst/src/.vimrc $HOME/_vimrc || echo "skipped"
    ln -si $dst/src/.gvimrc $HOME/_gvimrc || echo "skipped"
    ln -si "$dst/src/settings.json" "$vscode/settings.json" || echo "skipped"
    ln -si "$dst/src/keybindings.json" "$vscode/keybindings.json" || echo "skipped"
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
