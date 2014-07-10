# Get up and running

## Install Vagrant
https://www.vagrantup.com/

## Install gem dependencies
```
  $ bundle
```

## Install chef cookbooks
```
  $ librarian-chef install
```

## Install vagrant-omnibus
```
  $ vagrant plugin install vagrant-omnibus
```

## Build the VM
```
  $ vagrant up
```

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
Open `database.yml` and configure user / password of the postgresql database.

## Create and migrate database

```
  $ rake db:create
  $ rake db:migrate
```

## Start sidekiq workers
Sidekiq workers process background tasks as downloading episodes for example.

``
  $ bundle exec sidekiq
``

## Create admin user
There is no approved admin user in the database at this point as the database is empty. Therefore you need to create one.

Got to the website and create a new user. It will be in the database, but not approved for admin access.