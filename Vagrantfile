# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# To enable zsh, please set ENABLE_ZSH env var to "true" before launching vagrant up
#   + On Windows => $env:ENABLE_ZSH="true"
#   + On Linux   => export ENABLE_ZSH="true"

Vagrant.configure("2") do |config|

  # Define Minikube VM
  config.vm.define "minikube" do |minikube|

    # VM box
    minikube.vm.box = "eazytrainingfr/centos7"
    # minikube.vm.box = "generic/centos9s"

    # Network configuration
    minikube.vm.network "private_network", ip: "192.168.50.5"

    # Hostname
    minikube.vm.hostname = "minikube"

    # Synced folder (Windows host)
    minikube.vm.synced_folder(
      "C:/Users/HP/Documents/stack/mini-projet-kubernetes",
      "/home/vagrant/mini-projet-kubernetes"
    )

    # VirtualBox provider settings
    minikube.vm.provider "virtualbox" do |v|
      v.name   = "minikube"
      v.memory = 4096
      v.cpus   = 2
    end

    # Provisioning script
    minikube.vm.provision "shell",
      path: "install_minikube.sh",
      env: { "ENABLE_ZSH" => ENV["ENABLE_ZSH"] }

  end
end
