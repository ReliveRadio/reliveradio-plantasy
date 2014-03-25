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
```
  $ vagrant ssh
  $ cd app
  $ bundle
```

## Mailserver configuration

Create a configuration file `app/config/application.yml` and setup your mailserver credentials:

```
MAILER_PASSWORD: hackme
MAILER_FROM_ADDRESS: reliveradio-reminder@i42n.auriga.uberspace.de
MAILER_USERNAME: reliveradio-reminder@i42n.auriga.uberspace.de
MAILER_DOMAIN: i42n.auriga.uberspace.de
MAILER_SERVER_ADDRESS: auriga.uberspace.de
```

## Start sidekiq workers

``
  $ bundle exec sidekiq
``