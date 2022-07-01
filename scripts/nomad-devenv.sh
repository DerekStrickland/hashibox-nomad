#!/bin/bash

# Install development environment dependencies
# The go installation step depends on images 
# having been provisioned with NOMAD_SRC envar
# set so that the Nomad source is available.
bolt command run "sudo apt update" --targets=server-1
bolt command run "sudo apt upgrade -y" --targets=server-1
bolt command run "sudo apt -y install build-essential" --targets=server-1
bolt command run "sudo apt -y install make" --targets=server-1
bolt command run "sudo /home/vagrant/nomad/scripts/vagrant-linux-priv-go.sh" --targets=server-1
bolt command run "go version" --targets=server-1
bolt command run "git clone https://github.com/hashicorp/hcl" --targets=server-1
bolt command run "(cd hcl && go build -o hclfmt ./cmd/hclfmt)" --targets=server-1
bolt command run "sudo cp ./hcl/hclfmt /usr/local/bin/hclfmt" --targets=server-1
bolt command run "hclfmt -version" --targets=server-1
