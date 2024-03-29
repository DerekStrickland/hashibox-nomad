.PHONY: up halt restart destroy init sync update ssh

export VAGRANT_EXPERIMENTAL="dependency_provisioners"

#
# up is a shortcut to start the Vagrant environment.
#
up:
	vagrant up

#
# halt is a shortcut to stop the Vagrant environment.
#
halt:
	vagrant halt

#
# restart is a shortcut to properly stop and restart the Vagrant environment.
#
restart: halt
	vagrant up

#
# destroy is a shortcut to stop and force destroy the Vagrant environment.
#
destroy: halt
	vagrant destroy -f

#
# init is a shortcut to initialize the `hashibox` environment for the first time.
#
init:
	vagrant up --no-provision
	./scripts/upload.sh
	./scripts/install.sh

#
# sync is a shortcut to synchronize the local `upload` directory with the
# appropriate targeted nodes. It also applies some environment variables and
# then restarts the Consul, Nomad, and Vault services.
#
sync:
	./scripts/upload.sh
	./scripts/dotenv.sh
	./scripts/restart.sh

#
# update is a shortcut to update Consul, Nomad, Vault, and Docker on every nodes.
#
update:
	./scripts/update.sh

#
# ssh is a shortcut to ensure that the Nomad user's known hosts file is
# populated with GitHub and Bitbucket hosts, as described here:
# https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
#
ssh:
	bolt command run "sudo mkdir -p /root/.ssh" --targets=us --run-as root
	bolt command run "ssh-keyscan github.com | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
	bolt command run "ssh-keyscan bitbucket.org | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
