#!/bin/bash

grep -v "dot.bashrc" ~/.profile > ~/.profile.temp
mv ~/.profile.temp ~/.profile

grep -v "dot.bashrc" ~/.bashrc > ~/.bashrc.temp
mv ~/.bashrc.temp ~/.bashrc

grep -v "dot.vimrc" ~/.vimrc > ~/.vimrc.temp
mv ~/.vimrc.temp ~/.vimrc

grep -v "PATH=\$PATH:" ./dot.bashrc > ./dot.bashrc.temp
mv ./dot.bashrc.temp ./dot.bashrc

rm -rf ~/.vim/pack/vendor/start/nerdtree
rm -rf ~/.vim/pack/vendor/start/tagbar

