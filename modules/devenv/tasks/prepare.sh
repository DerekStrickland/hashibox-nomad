#!/bin/bash

# Install required and useful packages.
echo "==> Installing `apt` packages..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
  curl \
  unzip \
  vim \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common \
  build-essential \
  make

echo "==> Installing `go`..."
sudo /home/vagrant/nomad/scripts/vagrant-linux-priv-go.sh

echo "==> `go` version"
go version

echo "==> Cloning `hcl` repository..."
git clone https://github.com/hashicorp/hcl

echo "==> Building `hclfmt` binary..."
(cd hcl && go build -o hclfmt ./cmd/hclfmt)

echo "==> Installing `hclfmt`..."
sudo mkdir -p /opt/gopath/bin
sudo mv ./hcl/hclfmt /opt/gopath/bin

echo "==> `hclfmt` version"
hclfmt -version

# Create the HashiBox environment file.
echo "==> Creating environment file..."
touch /hashibox/.env
