web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: TERM_CHILD=1 RESQUE_TERM_TIMEOUT=20 bundle exec rake jobs:work
