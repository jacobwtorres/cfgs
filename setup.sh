#!/bin/bash

echo "source $PWD/dot.bashrc" >> ~/.profile
echo "source $PWD/dot.bashrc" >> ~/.bashrc
echo "so $PWD/dot.vimrc" >> ~/.vimrc

echo "export PATH=\$PATH:${PWD}" >> dot.bashrc

source $PWD/dot.bashrc

mkdir -p ~/.config/dbxcli/
openssl enc -d -aes-192-cbc -in db.0 > ~/.config/dbxcli/auth.json
