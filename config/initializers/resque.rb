# Setup for Heroku
Resque.redis = ENV["REDISTOGO_URL"] if ENV["REDISTOGO_URL"]
Resque.redis ||= ENV["REDISCLOUD_URL"] if ENV["REDISCLOUD_URL"]

# Setup for Heroku
#
# Resque uses forking to create new worker processes. The main process
# connection should be disconnected before forking (to avoid consuming
# unnecessary resources) while worker connections should be established after
# the fork occurs.
#
# https://devcenter.heroku.com/articles/forked-pg-connections#resque-ruby-queuing

Resque.before_fork do
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

Resque.after_fork do
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Require HTTP Basic Auth to view dashboard
if ENV["RESQUE_HTTP_USER"] && ENV["RESQUE_HTTP_PASSWORD"]
  Resque::Server.use(Rack::Auth::Basic) do |user, password|
    user == ENV["RESQUE_HTTP_USER"] and password == ENV["RESQUE_HTTP_PASSWORD"]
  end
end

LOGGERS = [Rails.logger, Resque.logger]

def write_to_loggers(msg)
  LOGGERS.each{|logger| logger.debug(msg)}
end

def write_to_loggers_info(msg)
  LOGGERS.each{|logger| logger.info(msg)}
end
