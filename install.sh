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