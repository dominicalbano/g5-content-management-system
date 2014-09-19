source "https://rubygems.org"
ruby "2.1.2"

gem 'rails', "4.1.5"
# Downgraded jquery-rails for Ember Views
gem "jquery-rails", "~> 3.0.4"
gem "jquery-ui-rails"

gem "quiet_assets"
gem "bootstrap-sass"
gem "bourbon"
gem "heroku_resque_autoscaler"
gem "microformats2"
gem "github_heroku_deployer"
gem "g5_sibling_deployer_engine"
gem "liquid"
gem "ckeditor"
gem "non-stupid-digest-assets"
gem "draper"
gem "coffee-script"
gem "ranked-model"
gem "aws-sdk"
gem "httparty"

gem "ember-rails"

gem 'g5_authenticatable', '~> 0.2'

# Temporary fix
gem "sprockets", "=2.11.0"
gem "sass-rails"
gem "coffee-rails"
gem "uglifier"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "railroady"
end

group :development, :test do
  # secrets
  gem "dotenv-rails"
  # debugging
  gem "pry"
  # database
  gem "sqlite3"
  # ruby specs
  gem "timecop"
  gem "rspec-rails"
  gem "rspec-its"
  gem "shoulda-matchers"
  # ruby request specs
  gem "capybara", "2.3.0"
  gem "capybara-webkit"
  gem "launchy"
  gem "selenium-webdriver", "2.41.0"
  gem "database_cleaner"
  # ruby spec support
  gem 'factory_girl_rails'
  gem "fabrication"
  gem "faker"
  gem "webmock", require: false
  gem "vcr", require: false
  # ruby spec coverage
  gem "codeclimate-test-reporter", require: false
  # guard specs
  gem "guard-rspec", require: false
  gem "rb-fsevent"
  # server processes runner
  gem "foreman"
end

group :production do
  gem "unicorn"
  gem "lograge"
  gem "pg"
  gem "rails_12factor"
  gem "newrelic_rpm"
  gem "dalli"
  gem "memcachier"
  gem "honeybadger"
end
