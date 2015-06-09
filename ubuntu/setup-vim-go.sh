#!/bin/bash

set -x

sudo apt-get update
sudo apt-get install -y vim

# Unset GOROOT else vundle in vim doesn't install
# go plugins.

export GOROOT=
export GOPATH="/usr/local/go"

gofile="/usr/local/go1.4.2.linux-amd64.tar.gz"

# First, wget the go tarball for ubuntu amd64.
if [ ! -f $gofile ]; then
    sudo wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz -P /usr/local/
fi

sudo tar xzf $gofile -C /usr/local/bin

shell_username=`id -u -n`
shell_groupname=`id -g -n`

sudo chown -R $shell_username:$shell_groupname $GOPATH
export PATH=$PATH:$GOPATH/bin/

# Now, install all plugins defined in vimrc.
cp ../vimrc ~/.vimrc

# The qall is for "quit all", and lets us run vim commands
# without opening vim.
vim +PluginInstall +qall

# Install Go binaries
vim +GoInstallBinaries +qall

# Finally put in GOPATH and GOBIN in the shell.
# Also, don't forget to export GOPATH 
echo "export GOPATH=/usr/local/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc

exit 0