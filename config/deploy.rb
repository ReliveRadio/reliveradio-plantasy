set :application, 'plantasy'
set :deploy_user, 'deploy'

# setup repo details
set :scm, :git
set :repo_url, 'https://github.com/ReliveRadio/reliveradio-plantasy'

# allow use of sudo
set :pty, true
set :forward_agent, true

# setup rbenv
# requires rbenv preinstalled on the server
set :rbenv_type, :system
set :rbenv_ruby, '2.1.2'
set :rbenv_custom_path, '/opt/rbenv'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep for rollback
set :keep_releases, 5

# files we want symlinking to specific entries in shared
# creates symlink from generic shared folder to current release shared folder
set :linked_files, %w{config/application.yml config/sidekiq.yml config/mpd.conf}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

set :templates_path, "config/deploy/templates"

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

# As of Capistrano 3.1, the `deploy:restart` task is not called
# automatically.
after 'deploy:publishing', 'deploy:restart'
after 'deploy:finishing', 'deploy:cleanup'
before :deploy, 'setup'
