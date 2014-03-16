# -*- mode: ruby -*-
# vi: set ft=ruby :

# do not fogert to install omnibus plugin
# 'vagrant plugin install vagrant-omnibus'

Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest

  config.vm.network "forwarded_port", guest: 8000, host: 8000 #icecast2
  config.vm.network "forwarded_port", guest: 6600, host: 6600 #mpd

  config.vm.synced_folder "app/", "/home/vagrant/app", :create => true
  config.vm.synced_folder "music/", "/home/vagrant/music", :create => true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "rvm::system"
    chef.add_recipe "git"
    chef.add_recipe "mpd"
    chef.add_recipe "icecast2"
    #chef.add_recipe "rails_application"
    #chef.add_recipe "postgresql"
    #chef.add_recipe "mysql::server"

    chef.json.merge!({
      :rvm => {
        :default_ruby => 'ruby-2.1.1'
      },
      :mysql => {
        "server_root_password" => "root",
        "server_repl_password" => "root",
        "server_debian_password" => "root",
        "allow_remote_root" => true
      }
    })
  end

  config.vm.provision "shell", inline: "sudo chown -R vagrant /usr/local/rvm"
end
