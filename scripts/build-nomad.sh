#!/bin/bash

# Run the "build-nomad" plan on nomad server and client nodes.
bolt plan run server::build_nomad --targets=servers --run-as root --log-leve trace
bolt plan run client::build_nomad --targets=clients --run-as root
