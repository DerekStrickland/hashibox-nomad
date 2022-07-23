sudo nomad agent -dev -config=uploads/devenv/127.0.0.1/nomad &
sudo consul agent -dev -config=uploads/devenv/127.0.0.1/consul &
sudo vault agent -dev -config=uploads/devenv/127.0.0.1/vault
