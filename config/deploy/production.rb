set :stage, :production
set :branch, "feature/capistrano"

# This is used in the Nginx VirtualHost to specify which domains
# the app should appear on. If you don't yet have DNS setup, you'll
# need to create entries in your local Hosts file for testing.
set :server_name, "www.s17837361.onlinehome-server.info s17837361.onlinehome-server.info"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

set :user, "deploy"
server 's17837361.onlinehome-server.info', user: fetch(:user), roles: %w{web app db}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# number of the sidekiq workers
set :sidekiq_concurrency, 5

# set :mpd_channels, %w{mix tech}

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false

ask :icecast_password, "hackme"