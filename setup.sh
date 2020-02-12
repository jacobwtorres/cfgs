#!/bin/bash

echo "source $PWD/dot.bashrc" >> ~/.profile
echo "source $PWD/dot.bashrc" >> ~/.bashrc
echo "so $PWD/dot.vimrc" >> ~/.vimrc

echo "export PATH=\$PATH:${PWD}" >> dot.bashrc

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: ' >&2
  exit 1
fi

#git setup
read -p "Set git config? (y/N): " git_setup
if [[ $git_setup =~ [y,Y] ]]; then
    read -p "Enter name for git: " gitname
    read -p "Enter email for git: " gitmail
    git config --global user.name "$gitname"
    git config --global user.email "$gitmail"
    git config --global core.editor "vim"
fi

#vim plugin install using built-in package manager (available starting vim 8)
if [[ ! -d ~/.vim/pack/vendor/start/nerdtree ]]; then
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
fi

if [[ ! -d ~/.vim/pack/vendor/start/tagbar ]]; then
    git clone https://github.com/majutsushi/tagbar.git ~/.vim/pack/vendor/start/tagbar

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! [ -x "$(command -v brew)" ]; then
            echo 'Error: brew is not installed. Install brew and then issue command: $ brew install ctags' >&2
            exit 1
        fi
        brew install ctags
    else
        apt-get install exuberant-ctags #required by tagbar vim plugin
    fi

fi

source $PWD/dot.bashrc

