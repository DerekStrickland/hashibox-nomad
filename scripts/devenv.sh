#!/bin/bash

# Run the "install" plan on server and client nodes.
bolt plan run devenv::install --targets=servers --run-as root
