# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Configure the VM options.

  # Attach the source code.
  nomad_src = ENV["NOMAD_SRC"]
  # Attach the enterprise source code.
  nomad_ent_src = ENV["NOMAD_ENT_SRC"]

  config.vm.box = "bento/ubuntu-#{ENV['UBUNTU_VERSION']}"
  config.vm.hostname = "hashibox"

  # Create 3 nodes acting as servers for Consul, Nomad, and Vault, each exposing
  # a private network.
  (1..3).each do |i|
    config.vm.define "node-server-#{i}" do |node|
      if nomad_src != '' 
        node.vm.synced_folder nomad_src, "/home/vagrant/nomad"
      end

      if nomad_ent_src != '' 
        config.vm.synced_folder nomad_ent_src, "/home/vagrant/nomad-enterprise"
      end

      node.vm.hostname = "node-server-#{i}"
      node.vm.network "private_network", ip: "192.168.60.#{i}0"

      node.vm.provider "parallels" do |v|
        v.memory = "#{ENV['VAGRANT_SERVER_RAM']}"
        v.cpus = "#{ENV['VAGRANT_SERVER_CPUS']}"
      end

      node.vm.provider "virtualbox" do |v|
        v.memory = "#{ENV['VAGRANT_SERVER_RAM']}"
        v.cpus = "#{ENV['VAGRANT_SERVER_CPUS']}"
      end

      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "#{ENV['VAGRANT_SERVER_RAM']}"
        v.vmx["numvcpus"] = "#{ENV['VAGRANT_SERVER_CPUS']}"
      end
    end
  end

  # Create 3 nodes acting as clients for Consul and Nomad agents, each exposing
  # a private network. Start Docker as well for running Nomad jobs inside
  # containers.
  (1..3).each do |i|
    config.vm.define "node-client-#{i}" do |node|
      if nomad_src != '' 
        node.vm.synced_folder nomad_src, "/home/vagrant/nomad"
      end

      if nomad_ent_src != '' 
        config.vm.synced_folder nomad_ent_src, "/home/vagrant/nomad-enterprise"
      end

      node.vm.hostname = "node-client-#{i}"
      node.vm.network "private_network", ip: "192.168.61.#{i}0"

      node.vm.provider "parallels" do |v|
        v.memory = "#{ENV['VAGRANT_CLIENT_RAM']}"
        v.cpus = "#{ENV['VAGRANT_CLIENT_CPUS']}"
      end

      node.vm.provider "virtualbox" do |v|
        v.memory = "#{ENV['VAGRANT_CLIENT_RAM']}"
        v.cpus = "#{ENV['VAGRANT_CLIENT_CPUS']}"
      end

      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "#{ENV['VAGRANT_CLIENT_RAM']}"
        v.vmx["numvcpus"] = "#{ENV['VAGRANT_CLIENT_CPUS']}"
      end
    end
  end
end
