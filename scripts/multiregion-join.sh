#!/bin/bash

# Make sure a `hashibox` directory exists. It's not the case when initializing
# the Vagrant environment for the first time. If this directory doesn't exist
# then all uploads and services will fail since it relies on it.
bolt command run "NOMAD_ADDR=http://192.168.60.20:4646 nomad server join 192.168.60.10:4648" --targets=server-2 --run-as root
bolt command run "NOMAD_ADDR=http://192.168.60.30:4646 nomad server join 192.168.60.10:4648" --targets=server-3 --run-as root
