# Get up and running

This document describes the setup process of a server to run the reliveradio-plantasy installation. If you want to create a vagrant VM on your local machine instead, [please take a look at this guide](README_VM.md).

There are three basic steps:

1. Get a server with Ubuntu installed
2. Run the chef recipe to provision the server with the required packages
3. Use the capistrano deployment tools to configure the services

## Setup basic system
This kitchen requires `Ubuntu 14.04` (headless) on the server and root access. You might consider running `apt-get update` and `apt-get upgrade` after setting up the system to install all security patches.

## Add deploy user and grant sudo access

```
adduser deploy
adduser deploy sudo
```

## Upload your own SSH key
Copy your ssh key to the server as password login will be disabled by the chef provisioning in the next step.

```
ssh-copy-id -i <path to your ssh public key> <server ip or domain>

Example:
ssh-copy-id -i /Users/stefan/.ssh/id_rsa.pub deploy@s17837361.onlinehome-server.info
```

## Run kitchen

With chef the server will be prepared for the app. It will install all required packages and requirements. The *kitchen* repository can be found [here](https://github.com/ReliveRadio/reliveradio-plantasy-kitchen/tree/master).

* Download/Clone it somewhere onto your client machine.
* Run `bundle` in the directory to install all required gems
* Run `librarian-chef install` to download all the recipe dependencies

Now you need to install chef on the server first with the `prepare` command.
```
knife solo prepare <server ip or domain>

Example:
knife solo prepare deploy@s17837361.onlinehome-server.info
```

This will create a file `nodes/yourservername.json`. You now need to copy all settings from the example file `nodes/s17837361.onlinehome-server.json` to your json file.

Now it is time to provision the server.
```
knife solo cook <server ip or domain>

Example:
knife solo cook deploy@s17837361.onlinehome-server.info
```

## Configure app settings
Clone this repository to your local machine.

Back in the `reliveradio-plantasy` project directory you have to preconfigure some server settings. Copy `config/application_example.yml` to `config/application.yml` and adjust the settings.

## Use Capistrano to deploy the app
Capistrano will configure all the services on the server. Make sure you run `bundle intall` before to install all the required packages on your client machine.

Adjust the server domain/ip settings in `config/deploy/production.rb` to point capistrano to the correct server.

Upload all the configuration files for the services:
```
cap production setup
```

Deploy the app:
```
cap production deploy
```

Restart all services on the server to adapt to the new configuration.
```
cap production restart_all
```
If you deploy future releases to the server be careful with the *restart_all*  command as it breaks the stream by restarting the *icecast* and *mpd* service. There is also a *restart_web* command to only restart *nginx* and *unicorn* if only the website changed.

With `cap production monit:status` you can see if all the services are running.

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