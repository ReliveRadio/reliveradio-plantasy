# -*- mode: ruby -*-
# vi: set ft=ruby :

# do not fogert to install omnibus plugin
# 'vagrant plugin install vagrant-omnibus'

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-12.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest

  config.vm.network "forwarded_port", guest: 3000, host: 3000 #rails, thin
  config.vm.network "forwarded_port", guest: 8080, host: 8080 #nginx, passenger
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
    chef.add_recipe 'rvm::gem_package'

    chef.add_recipe "git"
    chef.add_recipe "mpd"
    chef.add_recipe "icecast2"
    chef.add_recipe "nginx::source"
    chef.add_recipe "nginx::passenger"

    chef.json.merge!({
      :rvm => {
        :default_ruby => 'ruby-2.1.1',
        :vagrant => {
          :system_chef_solo => '/opt/chef/bin/chef-solo' #required to make vagrant-omnibus work together with rvm
        }
      },
      :nginx => {
        :source => {
          :modules => [
            "nginx::passenger"
          ]
        },
        :passenger => {
          :version => "4.0.38",
          :ruby => "/usr/local/rvm/rubies/ruby-2.1.1/bin/ruby",
          :root => "/usr/local/rvm/gems/ruby-2.1.1/gems/passenger-4.0.38"
        }
      }
    })
  end

  config.vm.provision "shell", inline: "sudo chown -R vagrant /usr/local/rvm"
end
