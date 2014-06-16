# Get up and running

## Install build-essential
Will be required to compile (ruby, nginx)

## Install ruby 2.1.1 (for example with rvm)

## Install nginx with passenger plugin
Not all distributions come with prebuild nginx including passenger. You may have to compile it yourself.

Example for `nginx.conf` that uses passenger [can be found here](https://github.com/i42n/nginx/blob/328b9aa75e0f1904faab2fadd900d24d8df83cde/templates/default/nginx.conf.erb#L88)

## Install redis database and postgresql database

## Install icecast2

## Install mpd
Launch one mpd instance for each channel. Therefore create initfile `"/etc/init.d/" + channel[:name]` and configfile `"/etc/" + channel[:name] + ".conf"` per channel.

The templates used for the VM setup [can be found here for reference.](https://github.com/i42n/chef-cookbook-mpd/tree/ad670efaf1bc91b1e4e007ef75dc6a69d3043ecf/templates/default)

Also do not forget to connect each mpd instance to icecast by configuring an audio output mountpont in the config file. [Example here.](https://github.com/i42n/chef-cookbook-mpd/blob/ad670efaf1bc91b1e4e007ef75dc6a69d3043ecf/templates/default/mpd.conf.erb#L126)

Important: Create socket files like `mpd_mix_socket` and make sure that they are configured correctly in the config file for the mpd instance. This socket file is the connection between the rails application and the mpd instance.

## Install missing packages
Install `imagemagick` and `taglib` package of the distribution. This is required for gems that create logo thumbnails and tagging audio files.
```
  $ sudo apt-get install imagemagick taglib
```

Sometimes also `nodejs` needs to be installed as rails uses this to compile assets.

## install app gems
```
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

If there are connection errors [this might be the cause.](https://stackoverflow.com/questions/5817301/rake-dbcreate-fails-authentication-problem-with-postgresql-8-4)

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