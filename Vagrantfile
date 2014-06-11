# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.hostname = "rb.dev"
  config.vm.network :private_network, ip: "10.0.20.2"
  config.vm.synced_folder "playground-central", "/var/hg/playground-central"
  config.vm.synced_folder "reviewboard-mercurial-hook", "/opt/reviewboard-mercurial-hook"

  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.provision "shell", path: "./setup.sh", privileged: false
end
