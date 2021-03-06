source "https://rubygems.org"
source "https://msc9777J2TEEbgRsedKE@gem.fury.io/g5dev/"

ruby "2.2.0"

gem "rails", "4.1.7"
gem "active_model_serializers", "~> 0.8.2"

gem "heroku_resque_autoscaler"
gem "microformats2"
gem "github_heroku_deployer"
gem "g5_sibling_deployer_engine"
gem "liquid"
gem "non-stupid-digest-assets"
gem "draper"
gem "coffee-script"
gem "ranked-model"
gem "aws-sdk"
gem "httparty"
gem "g5_authenticatable"
gem "pg"
gem "g5_header"

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
  gem "pry-byebug"
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
  gem "capybara"
  gem "launchy"
  # We need drag_by support on native elements:
  # https://github.com/teampoltergeist/poltergeist/pull/552
  # This should be released with v1.6.1 or v1.7.0
  gem "poltergeist", github: "teampoltergeist/poltergeist", ref: "f826d135dd54a91f674992e2b5cab60a081e39c"
  gem "database_cleaner"
  # ruby spec support
  gem 'factory_girl_rails'
  gem "fabrication"
  gem "faker"
  gem "fakefs", "0.6", :require => "fakefs/safe"
  gem "webmock", require: false
  gem "vcr", require: false
  # ruby spec coverage
  gem "codeclimate-test-reporter", require: false
  # guard specs
  gem "guard-rspec", require: false
  gem "rb-fsevent"
  gem "rspec-retry"
end  
