# G5 Client Hub

* Consumes gardens's feeds
* Creates and deploys location sites
* Consumes configurator's feed
* Updates a client hub deployer


## Setup

1. Install all the required gems.
```bash
$ bundle
```

1. Set up your database.
[rails-default-database](https://github.com/tpope/rails-default-database)
automatically uses sensible defaults for the primary ActiveRecord database.
```bash
$ rake db:setup
```

1. Configure your local instance of the widget garden. If you are using Foreman, the simplest way is to create a .env file which sets a WIDGET_GARDEN_URL variable to whatever server you are running locally, e.g. http://0.0.0.0:3001. If you aren't using Foreman you can still set one locally when you start up your server, i.e.
```bash
$ WIDGET_GARDEN_URL=http://0.0.0.0:3001 rails s
```
If you don't set this environment variable, the WIDGET_GARDEN_URL will default to the value set in config/constants/environment_variables.rb.

### Optional: To Seed a Client from the G5 Hub

In the previous step `$ rake db:setup` seeds a client from `spec/support/client.html`. If you want to seed a different client, this is what you do.

1. [Find a client UID on the g5-hub.](http://g5-hub.herokuapp.com)
It should look like: http://g5-hub.herokuapp.com/clients/g5-c-*

1. Export the client UID and run the rake task.
```bash
$ export G5_CLIENT_UID=found_client_uid
$ rake seed_client
```


### Optional: To Deploy Location Sites to Heroku

1. [Create a new private key and add it to Github.](https://help.github.com/articles/generating-ssh-keys)

1. [Add your private key to Heroku.](https://devcenter.heroku.com/articles/keys)

1. Export environment variables.
```bash
export G5_CLIENT_UID=client_uid
export HEROKU_USERNAME=your_username
export HEROKU_API_KEY=your_api_key
export ID_RSA=your_private_key
# HEROKU_APP_NAME is only needed in production for dyno autoscaling
export HEROKU_APP_NAME=g5-ch-*
```

1. Install [redis](http://redis.io/) and start it.
```bash
$ brew install redis
$ redis-server > ~/redis.log &
```

1. Use foreman to start the web and worker proccesses.
```bash
$ foreman start
```
Or if you are using pow or something start the job queue.
```bash
$ rake jobs:work
```


## Authors

  * Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
  * Bookis Smuin / [@bookis](https://github.com/bookis)
  * Chris Stringer / [@jcstringer](https://github.com/jcstringer)
  * Michael Mitchell / [@variousred](https://github.com/variousred)


## Contributing

1. Fork it
1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5-client-hub/issues).


## Deploy Topic Branch to Heroku

The Heroku Fork plugin copies over addons, database, and config vars.

```bash
$ heroku plugins:install https://github.com/heroku/heroku-fork
$ heroku fork -a g5-client-hub g5-ch-my-new-feature
$ git remote add g5-ch-my-new-feature git@heroku.g5:g5-ch-my-new-feature.git
$ git push g5-ch-my-new-feature my-new-feature:master
```


## Specs

Run once.

```bash
$ rspec spec
```

Keep them running.

```bash
$ guard
```


## Spec Coverage

The [simplecov](https://github.com/colszowka/simplecov) gem provides code
coverage for Ruby with a powerful configuration library and automatic merging
of coverage across test suites.

```bash
$ rspec spec
$ open coverage/index.html
```


## Model & Controller Diagrams

The [railroady](https://github.com/preston/railroady) gem generates Rails model
and controller UML diagrams as cross-platform .svg files, as well as in the DOT
language.

```bash
$ brew install graphviz
$ rake diagram:all
$ open doc/*.svg
```


## CSS Naming Conventions

Most CSS will go inside the modules folder. A module is simply a reusable chunk of CSS. To create a new module do the following:

1. Create a new file inside the modules folder. It should start with an underscore and contain the module name. Example: _panel.css.scss
1. The module name is the base class, which contains the basic styles for the module. Example: .panel
1. If there are multiple words in the base class, use dashes. Example: .my-panel
1. Any component, or part, of the module is a sub-module. The class should be the module name, a dash, and the sub-module. Example: .panel-title, .panel-footer
1. For any alternate styles of the module the class should be module name, two dashes, and the alternate style name. Example: .panel--b, .panel--large


