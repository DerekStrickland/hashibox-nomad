#!/bin/bash

devenv="devenv"
if [ "$1" ]
  then
    devenv=$1
    echo $devenv
fi

# Install development environment dependencies
# The go installation step depends on images 
# having been provisioned with NOMAD_SRC envar
# set so that the Nomad source is available.
bolt command run "sudo apt update" --targets=$devenv
bolt command run "sudo apt upgrade -y" --targets=$devenv
bolt command run "sudo apt -y install build-essential" --targets=$devenv
bolt command run "sudo apt -y install make" --targets=$devenv
bolt command run "sudo apt -y install moreutils" --targets=$devenv

# Go
bolt command run "sudo /home/vagrant/nomad/scripts/vagrant-linux-priv-go.sh" --targets=$devenv
bolt command run "go version" --targets=$devenv

# hclfmt
bolt command run "git clone https://github.com/hashicorp/hcl" --targets=$devenv
bolt command run "(cd hcl && go build -o hclfmt ./cmd/hclfmt)" --targets=$devenv
bolt command run "sudo cp ./hcl/hclfmt /usr/local/bin/hclfmt" --targets=$devenv
bolt command run "hclfmt -version" --targets=$devenv

# GitCredentialManager
bolt command run "wget https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.785/gcm-linux_amd64.2.0.785.deb" --targets=$devenv
bolt command run "sudo dpkg -i gcm-linux_amd64.2.0.785.deb" --targets=$devenv

# applicable.
if [[ ! -z ${GOPRIVATE} ]]; then
  bolt command run "echo GOPRIVATE=github.com/hashicorp | tee -a /hashibox/.env" --targets=$devenv --run-as root
fi

vagrant scp ~/.ssh/id_ed25519 node-server-1:/home/vagrant/.ssh
vagrant scp ~/.ssh/id_ed25519.pub node-server-1:/home/vagrant/.ssh
git config --global user.name "Derek Strickland"
git config --global user.email "derek.strickland@gmail.com"
eval "$(ssh-agent -s)"
touch ~/.ssh/config
vim ~/.ssh/config
Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519
git config --global url."git@github.com:".insteadOf "https://github.com/"
