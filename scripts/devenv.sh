#!/bin/bash

# Install development environment dependencies
bolt command run "sudo apt update" --targets=servers --run-as root
bolt command run "sudo apt -y upgrade" --targets=servers --run-as root
bolt command run "sudo apt -y install make" --targets=servers --run-as root
bolt command run "sudo apt -y install golang" --targets=servers --run-as root

bolt command run "sudo apt update" --targets=clients --run-as root
bolt command run "sudo apt -y upgrade" --targets=clients --run-as root
bolt command run "sudo apt -y install make" --targets=clients --run-as root
bolt command run "sudo apt -y install golang" --targets=clients --run-as root
