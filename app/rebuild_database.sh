#! /bin/bash
# rebuild schema.rb and databaes from migrations

rake db:drop RAILS_ENV="test" && rake db:drop RAILS_ENV="development" && rake db:create && rake db:migrate RAILS_ENV="test" && rake db:migrate RAILS_ENV="development"