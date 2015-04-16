if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "rspec/its"
require "capybara/rails"
require "capybara/rspec"
require "database_cleaner"
require "webmock/rspec"
require "vcr"
require 'g5_authenticatable/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)

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
  # rspec --tag deployment
  # (`--tag` is `-t` for short)
  # likewise the integration tests can be run with:
  # rspec --tag integration
  config.filter_run_excluding :integration, :deployment
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    # Temporary fix for default_url_host not being properly set in Rails 4.1.0
    Rails.application.routes.default_url_options = { host: "localhost:3000", port: nil }
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

  config.after(:suite) do
    puts "\n\nReminder: \033[1;31m\Don't forget to run integration specs with rspec -t integration\e[0m"
    end
  config.mock_with :rspec do |mocks|

    # This option should be set when all dependencies are being loaded
    # before a spec run, as is the case in a typical spec helper. It will
    # cause any verifying double instantiation for a class that does not
    # exist to raise, protecting against incorrectly spelt names.
    mocks.verify_doubled_constant_names = true

  end
end

def underscore_slug(str)
  str.downcase.gsub(' ','_').gsub('.','').underscore if str
end

def load_yaml_file(path)
  HashWithIndifferentAccess.new(YAML.load_file(path)) if File.exists?(path)
end

def load_website_yaml_file(file)
  load_yaml_file("#{Rails.root}/config/defaults/websites/#{file}.yml")
end

def set_selenium_window_size(width, height)
  window = Capybara.current_session.driver.browser.manage.window
  window.resize_to(width, height)
  # Config for rspec retry
  config.verbose_retry = true # show retry status in spec process
end

require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  # Default timeout is 30, but that causes sporadic timeout errors
  # on the CI server
  Capybara::Poltergeist::Driver.new(app, timeout: 180)
end
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5
