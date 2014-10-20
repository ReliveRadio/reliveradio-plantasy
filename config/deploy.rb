set :application, 'plantasy'

# setup repo details
set :scm, :git
set :repo_url, 'https://github.com/ReliveRadio/reliveradio-plantasy'

# allow use of sudo
set :pty, false
#set :forward_agent, true

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
set :linked_files, %w{config/application.yml config/mpd_mix.conf config/mpd_tech.conf}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

set :templates_path, "config/deploy/templates"






task :restart_all do
	invoke 'monit:restart'
	sleep 10
	invoke 'monit:restart_all'
end

task :restart_web do
	invoke 'unicorn:restart'
	invoke 'nginx:restart'
end

task :restart_stream do
	invoke 'icecast:restart'
	invoke 'mpd:restart'
end

task :setup do
	invoke 'application:setup'
	invoke 'nginx:setup'
	invoke 'unicorn:setup_app_config'
	invoke 'unicorn:setup_initializer'
	invoke 'mpd:setup'
	invoke 'icecast:setup'

	invoke 'sidekiq:monit:config'
	invoke 'monit:setup'
end

after 'deploy:publishing', 'restart_web'
after 'deploy:finishing', 'deploy:cleanup'
