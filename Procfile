web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: RESQUE_TERM_TIMEOUT=10 bundle exec rake jobs:work
