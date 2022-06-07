#!/bin/bash

CLEAN ?= false

# Fail if Nomad source does not exist.
if [ ! -d "/home/vagrant/nomad" ]
then
    echo "==> Nomad source not available. Is NOMAD_SRC set on your host machine?"
    exit 1
fi

# Stop the current Nomad agent.
echo "==> Stopping running Nomad agent..."
sudo systemctl stop nomad

if [ ${CLEAN} == true ]; then \
    echo "==> Cleaning Nomad data directory..."
    sudo rm -rf /opt/nomad/*
fi

# Build Nomad binary.
echo "==> Building Nomad..."
(cd /home/vagrant/nomad && make deps)
(cd /home/vagrant/nomad && NOMAD_UI_TAG="ui" make dev)
sudo install /vagrant/home/nomad/bin/nomad /usr/local/bin/nomad

# If we made it here, we're done!
echo "==> Successfully updated Nomad"
sudo systemctl start nomad
