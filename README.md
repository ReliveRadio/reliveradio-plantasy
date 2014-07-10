# Get up and running

These instructions help you setting up a vagrant testing virtual machine. If you want to setup a deticated server system please consider the `README_deticated.md`.

The following steps are tested on MacOS. There also is [a video of the setup process](http://youtu.be/dA_KgoOUFKY). However it *does not include the vagrant installation*.

## Install Vagrant
https://www.vagrantup.com/

## Install vagrant-omnibus
```
  $ vagrant plugin install vagrant-omnibus
```

## Install gem dependencies
```
  $ bundle
```

## Install chef cookbooks
```
  $ librarian-chef install
```

## Build the VM
```
  $ vagrant up
```
Currently the provisioning process crashes at one point as the rvm environment does not get correctly applied to the vagrant session. If it breaks simply rerun the provision with `vagrant provision`. The new environment variables for the rvm ruby installation are then applied correctly and it works as expected.

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

## Configure database access
This step is not required if you use the VM locally for testing purposes. A default passwort will be set but it is not secure.

To set the password open `database.yml` and configure user / password of the postgresql database.

## Create and migrate database

```
  $ rake db:create
  $ rake db:migrate
```

## Test connection

Vagrant automatically configured a port mapping to your local machine. You should now be able access the ReliveRadio rails app on [http://localhost:8080](http://localhost:8080).

## Start sidekiq workers
Sidekiq workers process background tasks as downloading episodes for example.

``
  $ bundle exec sidekiq
``

## Create admin user
There is no approved admin user in the database at this point as the database is empty. Therefore you need to create one.

Go to the website and create a new user. It will be in the database, but not approved for admin access. You have to approve it with `rails console`.