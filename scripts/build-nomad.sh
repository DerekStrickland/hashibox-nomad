#!/bin/bash

################################################################################
# Usage:
#   build-nomad.sh [--b <rebuild binary>] [--d <clean data_dirs>] [--e build enterprise binary]
#   This script will build nomad binary and clean data_dirs on all nodes.
#   It is intended to be called by make targets that handle setting the
#   correct flags for different scenarios.
################################################################################

build_binary=false
clean_data_dirs=false
build_ent=false

while getopts 'bde' OPTION; do
  case "$OPTION" in
    b)
      build_binary=true
      ;;
    d)
      clean_data_dirs=true
      ;;
    e)
      build_ent=true
      ;;
    ?)
      echo "script usage: $(basename \$0) [-b build binary] [-d clean data dir]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Clients need to be drained before we can safely upgrade the binary or clean the data dir
nomad status | awk -F '\t' 'NR>1{print $1}' | cut -d " " -f1 | while read -r job_id; do
    echo "==> Purging job $job_id..."
    nomad job stop -purge $job_id
done

# Stop Nomad on all the machines. This is needed to make sure the binary is
# not in use by any other process while building.
# bolt command run "sudo systemctl disable nomad" --targets=devenv
bolt command run "sudo systemctl stop nomad" --targets=devenv

# Build the Nomad binary on the host machine.
if $build_binary; then
    src_dir="nomad"
    if $build_ent; then
        src_dir="nomad-enterprise"
    fi

    # Print the current git ref.
    # (cd $NOMAD_SRC && echo "Dev git ref ===>" && git rev-parse HEAD)
    bolt command run "cd $src_dir && echo \"Dev git ref ===>\" && git rev-parse HEAD" --targets=server-1
    
    # Build the Nomad binary.
    # (cd $NOMAD_SRC && GOOS=linux GOARCH=amd64 make dev)
    bolt command run "cd $src_dir && make dev" --targets=server-1

    # Print the built binary version.
    bolt command run "echo \"Built Nomad binary version ==>\" && ${src_dir}/bin/nomad -version" --targets=server-1

    # Replace the binary in the path on all nodes.
    # bolt command run @scripts/stop-nomad.sh --targets=devenv
    bolt command run "sudo cp ${src_dir}/bin/nomad /usr/local/bin/nomad && echo '/usr/local/bin/nomad version ==>' && nomad -version" --targets=devenv

    # Stat the binaries in output so timestamps can be compared.
    bolt command run "echo \"Built binary stat ==> \" && stat -c '%n %y' ${src_dir}/bin/nomad && echo \"Path binary stat ==> \" && stat -c '%n %y' /usr/local/bin/nomad" --targets=devenv

fi

if $clean_data_dirs; then
  # Clean the data_dirs on all nodes.
  echo "==> Cleaning data_dirs..."
  bolt command run "sudo grep /opt/nomad/data /proc/mounts | cut -f2 -d\" \" | sort -r | ifne xargs umount -n" --targets=devenv --run-as root
  bolt command run "sudo rm -rf /opt/nomad/data" --targets=devenv --run-as root
fi

# bolt command run "sudo systemctl enable nomad" --targets=devenv
bolt command run "sudo systemctl start nomad" --targets=devenv
