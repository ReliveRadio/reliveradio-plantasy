# Get up and running

This document describes the setup process of a VM to run the reliveradio-plantasy installation. If you want to setup a remote server instead, [please take a look at this guide](README_DEDICATED.md).

There are two basic steps:

1. Boot up vagrant and provision the server
3. Use the capistrano deployment tools to configure the services

## Setup basic system
Make sure you have `vagrant` with virtualbox support installed. Also install the `omnibus` plugin with `vagrant plugin install vagrant-omnibus`.

* [Clone this repository](https://github.com/ReliveRadio/reliveradio-plantasy-kitchen/tree/master) as it contains the vagrant configuration and chef recipes to provision the server.
* Run `bundle` in the directory to install all required gems
* Run `librarian-chef install` to download all the required recipes

Boot up and provision the VM with `vagrant up`. It will use the configuration from `nodes/vagrant.json`. If you change any recipes in the future, use `vagrant provision` to update the server provisioning.

## Configure app settings
Clone this repository to your local machine.

Back in the `reliveradio-plantasy` project directory you have to preconfigure some server settings. Copy `config/application_example.yml` to `config/application.yml` and adjust the settings.

## Use Capistrano to deploy the app
It makes a lot of sense to use the same deployment tools for the local vagrant VM like for the remote production server. Therefore we do not use the shared folders feature of vagrant.

Capistrano will configure all the services on the server. Make sure you run `bundle intall` before to install all the required packages on your client machine.

Adjust some settings in `config/deploy/vagrant.rb`. Here you can also define which branch of the app should be deployed to the VM.

Upload all the configuration files for the services:
```
cap vagrant setup
```

Deploy the app:
```
cap vagrant deploy
```

Restart all services on the server to adapt to the new configuration.
```
cap vagrant restart_all
```
If you deploy future releases to the server be careful with the *restart_all*  command as it breaks the stream by restarting the *icecast* and *mpd* service. There is also a *restart_web* command to only restart *nginx* and *unicorn* if only the website changed.

With `cap vagrant monit:status` you can see if all the services are running.

## Create an admin user for the web interface
At the current application state new admin users can register themselves via the website. However they have to be approved to gain admin access. When the app is just set up there is no approved admin user yet. You have to approve the first admin user request manually using the rails console on the server.

* Register a new admin via the web interface. It will be created but not be approved.
* SSH into the server
* `cd apps/plantasy-production/current`
* `bundle exec rails console production`
* `new_admin = Admin.first`
* `new_admin.approved = true`
* `new_admin.save`
* CTRL-D to leave the rails console

Now you can use the web interface to login as the new admin user as it is approved now. Further admin users can be approved in the web interface by all existing admin users.