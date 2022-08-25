.PHONY: up halt restart destroy init sync update unseal ssh

export VAGRANT_PROVIDER ?= "virtualbox"
export UBUNTU_VERSION ?= 20.04

export VAGRANT_SERVER_RAM ?= 512
export VAGRANT_SERVER_CPUS ?= 1

export VAULT_UNSEAL_KEY ?= "INSERT-VAULT-UNSEAL-KEY"

-include .env

#
# init is a shortcut to initialize the HashiBox environment for the first time.
# Apply the environment variables before installing so we know if we need OSS
# or Enterprise version for Consul, Nomad, and Vault.
#
init:
	vagrant up --provider=${VAGRANT_PROVIDER}
# TODO: Make it work with Consul/Vault 
# ./scripts/upload.sh
# ./scripts/dotenv.sh
# ./scripts/install.sh

#
# up is a shortcut to start the Vagrant environment. It also applies some
# environment variables, then restarts the Consul, Nomad, and Vault services and
# finally unseal Vault on every server nodes.
#
up:
	vagrant up --provider=${VAGRANT_PROVIDER}

# TODO: Make it work with Consul/Vault 
# ./scripts/dotenv.sh
# ./scripts/restart.sh
# sleep 5
# ./scripts/unseal.sh

#
# halt is a shortcut to stop the Vagrant environment.
#
halt:
	vagrant halt

#
# restart is a shortcut to properly stop and restart the Vagrant environment.
#
restart: halt up

#
# destroy is a shortcut to # and force destroy the Vagrant environment.
#
destroy: halt
	vagrant destroy -f

#
# unseal is a shortcut to unseal the Vault servers given a single unseal key.
# TODO: make it work with Vault
unseal:
	../scripts/unseal.sh


#
# install Nomad development environment dependencies 
#
nomad-deps:
	../scripts/nomad-devenv.sh "debug-server"

#
# update the nomad binary on all nodes and clean the data directory.
#
nomad-build:
	./scripts/build-nomad.sh -b -d

#
# update the nomad binary on all nodes and without cleaning the data directory.
#
nomad-build-only:
	./scripts/build-nomad.sh -b

#
# clean the nomad data directory.
#
nomad-clean:
	./scripts/build-nomad.sh -d




