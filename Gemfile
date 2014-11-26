source "https://rubygems.org"
ruby "2.1.5"

gem "rails", "4.1.7"
gem "active_model_serializers", "~> 0.8.2"

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
gem "momentjs-rails"
gem "ember-rails"
gem "ember-source", "~> 1.7.0"
gem "g5_authenticatable"
gem "pg"
gem "font-awesome-rails"

# Temporary fix
gem "sprockets"
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
  gem "dotenv-rails", "~> 0.11.1"
  # debugging
  gem "pry"
  # database
  gem "sqlite3"
  # server processes runner
  gem "foreman"
end

group :production do
  gem "unicorn"
  gem "lograge"
  gem "rails_12factor"
  gem "newrelic_rpm"
  gem "dalli"
  gem "memcachier"
  gem "honeybadger"
end

group :test do
  gem 'resque_spec'
  # ruby specs
  gem "timecop"
  gem "rspec-rails"
  gem "rspec-its"
  gem "shoulda-matchers"
  # ruby request specs
  gem "capybara", "2.3.0"
  gem "launchy"
  gem "selenium-webdriver"
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
end  
