#!/bin/bash

sudo systemctl stop nomad

# if systemctl status nomad > /dev/null
# then
#     echo "==> Stopping nomad..."
#     sudo systemctl stop nomad
#     echo "==> Waiting for nomad to stop..."
#     while systemctl status nomad > /dev/null
#     do
#         sleep 10
#     done
#     echo "==> nomad stopped"
# fi

while ! sudo cp nomad/pkg/linux_amd64/nomad /usr/local/bin/nomad
do
    echo "==> Waiting for nomad to stop..."
    sleep 3
done

echo '/usr/local/bin/nomad version ==>'

nomad -version
