# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails/tree/master/assets
#   https://github.com/capistrano/rails/tree/master/migrations
#
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/postgresql'
require 'capistrano/unicorn_nginx'
require 'capistrano/sidekiq'
require 'capistrano/sidekiq/monit'

# Loads custom tasks from lib
Dir.glob('config/deploy/lib/*.rb').each { |r| import r }
Dir.glob('config/deploy/lib/tasks/*.cap').each { |r| import r }
