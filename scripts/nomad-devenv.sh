#!/bin/bash

# Install development environment dependencies
# The go installation step depends on images 
# having been provisioned with NOMAD_SRC envar
# set so that the Nomad source is available.
bolt command run "sudo apt update" --targets=192.168.60.10 --run-as root
bolt command run "sudo apt upgrade -y" --targets=192.168.60.10 --run-as root
bolt command run "sudo apt -y install build-essential" --targets=192.168.60.10 --run-as root
bolt command run "sudo apt -y install make" --targets=192.168.60.10 --run-as root
bolt command run "sudo /home/vagrant/nomad/scripts/vagrant-linux-priv-go.sh" --targets=192.168.60.10 --run-as root
bolt command run "go version" --targets=192.168.60.10 --run-as root
bolt command run "git clone https://github.com/hashicorp/hcl" --targets=192.168.60.10 --run-as root
bolt command run "(cd hcl && go build -o hclfmt ./cmd/hclfmt)" --targets=192.168.60.10 --run-as root
bolt command run "sudo mkdir -p /opt/gopath/bin" --targets=192.168.60.10 --run-as root
bolt command run "sudo mv ./hcl/hclfmt /opt/gopath/bin" --targets=192.168.60.10 --run-as root
