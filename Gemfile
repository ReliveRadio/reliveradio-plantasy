source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.1.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# webframework
gem 'foundation-rails', '~> 5.2'
# nice icon font
gem 'font-awesome-rails', '~> 4.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# this breaks a lot of javascript so I disabled it.
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'rake'
gem 'json'
gem 'will_paginate'
gem 'will_paginate-foundation'
gem 'ransack'
gem 'feedjira'
gem 'chronic_duration'
gem 'acts-as-taggable-on'
gem 'carrierwave'
gem 'devise'
gem "devise-async"
gem 'sidekiq'
gem 'figaro'
gem 'acts_as_list'
gem 'sinatra', require: false
gem 'slim'
gem 'gravatar_image_tag'

gem 'mini_magick' # requires imagemagick package of the system distro to be installed. see: https://github.com/minimagick/minimagick

# audio
gem 'wavefile'
gem 'ruby-mpd'
gem 'taglib-ruby' # requires taglib package of the system distro installed! see: https://robinst.github.io/taglib-ruby/

# Use unicorn as the app server
gem 'unicorn'

# testing
group :test do
	gem 'test-unit'
	gem 'rspec-rails'
	gem 'factory_girl_rails'
	gem 'faker'
	gem 'capybara'
	gem 'guard-rspec'
	gem 'database_cleaner'
	gem 'vcr'
	gem 'timecop'
end

group :doc do
	# bundle exec rake doc:rails generates the API under doc/api.
	gem 'sdoc', require: false
end

group :development do
	# Use Capistrano for deployment
	gem 'capistrano'
	gem 'capistrano-ext'
	gem 'capistrano-rails'
	gem 'capistrano-bundler'
	gem 'capistrano-rbenv'
	#gem 'capistrano-sidekiq'
	#gem 'capistrano3-monit', github: 'naps62/capistrano3-monit'
	gem 'capistrano-postgresql', '~> 3.0'
	gem 'capistrano-unicorn-nginx', '~> 2.0'

	# Use debugger
	#gem 'debugger', group: [:development, :test]
	#use byebug instead as debugger 1.6.8 does not support ruby 2.1.2 yet.
	#https://github.com/cldwalker/debugger/issues/131
	gem 'byebug'
end