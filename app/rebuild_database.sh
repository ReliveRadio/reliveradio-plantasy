#! /bin/bash
# rebuild schema.rb and databaes from migrations

rake db:drop RAILS_ENV="test" && rake db:drop RAILS_ENV="development" && bundle exec rake db:schema:dump && rake db:migrate RAILS_ENV="test" && rake db:migrate RAILS_ENV="development"