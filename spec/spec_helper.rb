if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require "simplecov"
  SimpleCov.start
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "database_cleaner"
require "webmock/rspec"
require "vcr"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

VCR.configure do |config|
  config.cassette_library_dir = "spec/support/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_hosts "127.0.0.1", "localhost", "codeclimate.com"
  config.configure_rspec_metadata!
end

VCR_OPTIONS = { record: :new_episodes, re_record_interval: 7.days }

RSpec.configure do |config|
  config.order = "random"
  config.include Capybara::DSL, type: :request

  # Allows us to  use :vcr rather than :vcr => true
  # In RSpec 3 this will no longer be necessary
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # The integration deployment tests can be run with:
  # rspec -t type:deployment
  config.filter_run_excluding type: "deployment"

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
