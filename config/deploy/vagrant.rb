set :stage, :vagrant
set :branch, "develop"

# This is used in the Nginx VirtualHost to specify which domains
# the app should appear on. If you don't yet have DNS setup, you'll
# need to create entries in your local Hosts file for testing.
set :server_name, "vagrant"
set :icecast_hostname, "vagrant"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

set :user, "vagrant"
set :deploy_user, fetch(:user)
set :ssh_options, {port: 2222, keys: ['~/.vagrant.d/insecure_private_key']}
server 'localhost', user: fetch(:user), roles: %w{web app db}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

set :rails_env, :production

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# number of the sidekiq workers
set :sidekiq_concurrency, 5

# define channels here to launch multiple mpd instances
# IMPORTANT: add one config file link for each channel in :linked_files in deploy.rb! Example: config/mpd_mix.conf
set :mpd_channels, %w{mix tech}

set :nginx_use_ssl, false

set :sidekiq_queue, %w(default mailer)

set :monit_config_path, "/etc/monit/conf.d/"

set :icecast_pidfile, "/var/run/icecast.pid"

# if enabled capistrano will check if the deploy branch
# is pushed to the remote repository before deploying
set :check_revision_enabled, false

# if not set it will be auto generated
# ask :icecast_password, "hackme"