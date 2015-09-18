#!/bin/bash

#set -x

sudo yum update
sudo yum install -y vim wget

# Unset GOROOT else vundle in vim doesn't install
# go plugins.

export GOROOT=
export GOPATH="/usr/local/go"

gofile="/usr/local/go1.4.2.linux-amd64.tar.gz"

# First, wget the go tarball for ubuntu amd64.
if [ ! -f $gofile ]; then
    sudo wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz -P /usr/local/
fi

sudo tar xzf $gofile -C /usr/local/

shell_username=`id -u -n`
shell_groupname=`id -g -n`

sudo chown -R $shell_username:$shell_groupname $GOPATH
export PATH=$PATH:$GOPATH/bin/

# Now, install all plugins defined in vimrc.
cp ../vimrc ~/.vimrc

# The qall is for "quit all", and lets us run vim commands
# without opening vim.
vim +PluginInstall +qall

# Install Go binaries. We will need to set GOPATH temporarily
# to a directory where the user places go source files in a src/
# subdirectory.
echo "Enter a directory path that will be your GOROOT (the script will create this directory) : "
read GOROOT
# Create that directory
mkdir $GOROOT
mkdir $GOROOT/bin
mkdir $GOROOT/src
mkdir $GOROOT/pkg

export GOPATHORIG=$GOPATH
export GOROOTORIG=$GOROOT
export GOPATH=$GOROOT
export GOROOT=
vim +GoInstallBinaries +qall


echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
exit 0
