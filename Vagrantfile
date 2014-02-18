# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "10.0.20.2"
  # config.vm.network :public_network
  # config.vm.synced_folder ".", "/opt/reviewboard", type: "nfs"

  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.gui = true if ENV["DEBUG"]
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpus", 2]

    # seriously, there are no typos on the next line!
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", "1000"]
  end

  config.vm.provision "shell", path: "./setup.sh"
end
