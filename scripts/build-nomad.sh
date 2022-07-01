#!/bin/bash

# Rebuild and deploy the Nomad binary on clients and servers

# TODO: Delete these lines if the bold command approach works.
# Run the "build-nomad" plan on nomad server and client nodes.
# bolt plan run server::build_nomad --targets=servers --run-as vagrant --log-level trace
# bolt plan run client::build_nomad --targets=clients --run-as root

################################################################################
# Usage:
#   build-nomad.sh [--b <rebuild binary>] [--d <clean data_dirs>]
#   This script will build nomad binary and clean data_dirs on all nodes.
#   It is intended to be called by make targets that handle setting the
#   correct flags for different scenarios.
################################################################################

build_binary=false
clean_data_dirs=false

while getopts 'bd' OPTION; do
  case "$OPTION" in
    b)
      build_binary=true
      ;;
    d)
      clean_data_dirs=true
      ;;
    ?)
      echo "script usage: $(basename \$0) [-b build binary] [-d clean data dir]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Stop Nomad on all the machines. This is needed to make sure the binary is
# not in use by any other process while building.
bolt command run "sudo systemctl stop nomad" --targets=devenv

if $build_binary; then
  # 
  # Build the Nomad binary.
  bolt command run "cd nomad && make dev && echo 'Dev build nomad version ==>' && bin/nomad -version" --targets=server-1
  # Copy the binary to the gopath on all the nodes.
  bolt command run "sudo cp nomad/bin/nomad /usr/local/bin/nomad && echo '/usr/local/bin/nomad version ==>' && nomad -version" --targets=devenv
fi

if $clean_data_dirs; then
  # Clean the data_dirs on all the nodes.
  bolt command run "sudo grep /opt/nomad/data /proc/mounts | cut -f2 -d\" \" | sort -r | xargs umount -n" --targets=devenv
  bolt command run "sudo rm -rf /opt/nomad/data" --targets=devenv --run-as root
  bolt command run "sudo ls /opt/nomad" --targets=devenv --run-as root
fi

bolt command run "sudo systemctl start nomad" --targets=devenv --run-as root
