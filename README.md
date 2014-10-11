# Get up and running

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Debitis culpa beatae voluptatum sequi recusandae, fuga obcaecati aliquid? Molestias voluptatum eius, necessitatibus itaque sed quisquam molestiae quod est accusantium vitae illum.

## Setup basic system
This kitchen requires `Ubuntu 14.04` (headless) on the server and root access.

## Add deploy user and grant sudo access

## Upload your own SSH key
ssh-copy id

## Run kitchen

kitchen prepare
copy json settings from example
kitchen cook

## Configure app settings
Copy `config/application_example.yml` to `config/application.yml` and adjust the settings.

## Use Capistrano to deploy the app

cap production setup
cap production deploy
cap production restart_all

## Confirm admin user manually on the server
bundle exec rails console production