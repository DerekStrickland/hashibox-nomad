#!/bin/bash

echo "pushing bin $1"

if [ -z "$1" ]
  then
    echo "No path to bindary provided"
    exit 1
fi

if [[ $1 != *nomad ]]
then
    echo "Not a nomad binary"
    exit 1
fi

# Replace the binary in the path on all nodes.
# bolt command run "pwd" --targets=devenv
bolt command run "sudo systemctl stop nomad" --targets=devenv
bolt file upload $1 /usr/local/bin/nomad --targets=devenv --run-as root
bolt command run "echo '/usr/local/bin/nomad version ==>' && nomad -version" --targets=devenv
bolt command run "sudo systemctl start nomad" --targets=devenv
