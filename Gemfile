# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby('3.3.3')

source 'https://rubygems.pkg.github.com/acima-credit' do
  gem 'actionable', '0.1.5.pre.89dd455'
  gem 'container_tools', '1.0.7'
  gem 'denv', '0.3.3'
  gem 'dev_env', '0.1.3'
  gem 'simple_guid', '0.43.0'
  gem 'tool_box', '3.2.3'
end

gem 'encryptor'

gem 'anyway_config', '~> 2.1.0' # force to 2.1.0 because 2.2 has experimental ruby 2.7.x warnings

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5.6'
# Use Puma as the app server
gem 'puma', '>= 5'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

gem 'bcrypt'
gem 'newrelic_rpm', '>= 8'
gem 'require_all', '~> 2.0'

gem 'http', '~> 5.0.4'
gem 'net-scp'
gem 'net-ssh'

gem 'rswag-api'
gem 'rswag-ui'

# Mitigate a dependent security vulnerability
gem 'websocket-extensions', '>= 0.1.5' # actioncable(6.0.3.1) -> websocket-driver (0.7.2)

gem 'redis', '4.7.1' # stay back until throttled fixes its positional argument deprecations

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'faker', '~> 2.19.0', require: false
  gem 'pry-byebug', platform: :mri
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-instrumentation-matcher', '0.0.4'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner', '>= 2.0.1'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'hashdiff', ['>= 1.0.0.beta1', '< 2.0.0']
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers', '>= 5'
  gem 'simplecov', '> 0.20', require: false
  gem 'simplecov_json_formatter', require: false
  gem 'timecop', '~> 0.9.1'
  gem 'webmock', '~> 3.14.0'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rubocop', '1.21.0', require: false
  gem 'rubocop-rails'
  gem 'web-console', '>= 4.1.0'
end
