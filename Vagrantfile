# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-12.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024 # 512 does not work as nginx needs more to compile without memory error
    v.cpus = 1
  end
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Set the version of chef to install using the vagrant-omnibus plugin
  # do not fogert to install omnibus plugin
  # 'vagrant plugin install vagrant-omnibus'
  config.omnibus.chef_version = :latest

  config.vm.network "forwarded_port", guest: 3000, host: 3000 # rails, thin
  #config.vm.network "forwarded_port", guest: 80, host: 80 # nginx test page
  config.vm.network "forwarded_port", guest: 8080, host: 8080 # nginx, passenger
  config.vm.network "forwarded_port", guest: 8000, host: 8000 # icecast2
  config.vm.network "forwarded_port", guest: 6601, host: 6601 # mpd_mix
  config.vm.network "forwarded_port", guest: 6602, host: 6602 # mpd_tech
  #config.vm.network "forwarded_port", guest: 5432, host: 5432 # postgresql

  # sync the app folder to develop locally and see results live in the VM
  config.vm.synced_folder "app/", "/home/vagrant/app", :create => true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    
    # RECIPES

    # apt-get update
    chef.add_recipe "apt"

    # some packages
    chef.add_recipe "git"
    chef.add_recipe "mpd"
    chef.add_recipe "icecast2"
    chef.add_recipe "reliveradio-plantasy-cookbook" # some custom packages (imagemagick, taglib, ...)
    chef.add_recipe "nodejs::install_from_package"

    # ruby
    chef.add_recipe "build-essential"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "rvm::system"
    chef.add_recipe 'rvm::gem_package'
    # nginx passenger
    chef.add_recipe "wrapper-nginx-passenger"
    # database
    chef.add_recipe "redisio::install"
    chef.add_recipe "redisio::enable"
    chef.add_recipe "postgresql::server"

    chef.json.merge!({
      apt: {
        compile_time_update: true # force apt-get update BEFORE installing any packages
      },
      icecast2: {
        authentication: {
          # this is the password that mpd will use to connect to icecast
          :'source-password' => 'hackme'
        }
      },
      :rvm => {
        :default_ruby => 'ruby-2.1.2',
        :vagrant => {
          :system_chef_solo => '/opt/chef/bin/chef-solo' #required to make vagrant-omnibus work together with rvm
        }
      },
      :nginx => {
        # max upload size for jingle uploads
        :client_max_body_size => '50M',
        :passenger => {
          :root => "/usr/local/rvm/gems/ruby-2.1.2/gems/passenger-4.0.45",
          :version => "4.0.45",
          :ruby => "/usr/local/rvm/gems/ruby-2.1.2/wrappers/ruby",
          :port => "8080", # port of the rails app
          :app_root => "/home/vagrant/app/public" # path to the rails app
        }
      },
      mpd: {
        channels: {
          mix: {
            name: 'mpd_mix',
            bind: '0.0.0.0',
            socket: '/home/vagrant/.mpd/socket/mix',
            port: '6601',
            icecast_password: 'hackme'
          },
          tech: {
            name: 'mpd_tech',
            bind: '0.0.0.0',
            socket: '/home/vagrant/.mpd/socket/tech',
            port: '6602',
            icecast_password: 'hackme'
          }
        }
      },
      postgresql: {
        password: {
          postgres: 'hackme'
        },
        pg_hba: [{
          comment: '#https://stackoverflow.com/questions/5817301/rake-dbcreate-fails-authentication-problem-with-postgresql-8-4',
          type: 'local',
          db: 'all',
          user: 'all',
          method: 'trust'
        }]
      }
    })
  end

  config.vm.provision "shell", inline: "sudo chown -R vagrant /usr/local/rvm"
end
