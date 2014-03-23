# Get up and running

## Install VirtualBox
https://www.virtualbox.org/

## Install Vagrant
https://www.vagrantup.com/

## Install gem dependencies
``
  $ bundle
``

## Install chef cookbooks
``
  $ librarian-chef install
``

## Install vagrant-omnibus
``
  $ vagrant plugin install vagrant-omnibus
``

## Build the VM
``
  $ vagrant up
``

## Log in and install app gems
``
  $ vagrant ssh
  $ cd app
  $ bundle
``

## Start sidekiq workers

``
  $ bundle exec sidekiq
``