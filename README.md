# G5 Content Management System (CMS)

[![Build Status](https://travis-ci.org/G5/g5-content-management-system.svg?branch=master)](https://travis-ci.org/G5/g5-content-management-system)
[![Code Climate](https://codeclimate.com/repos/5114447913d6374d5000e638/badges/065a0ae50d3b8277ebb2/gpa.png)](https://codeclimate.com/repos/5114447913d6374d5000e638/feed)

- Seeds client from client uid
- Seeds default website for each location
- Gardens provide components that make up websites and web pages
- Page builder allows for customization of web pages
- Websites compile and deploy to Heroku
- Read's configurator's feed and updates sibling applications


## Setup

1. Install all the required gems.

    ```bash
    $ bundle
    ```

1. Set environment variables.

    - For local development defaults in `.env` can be overriden by setting
      the variable in `.env.development`. For example:

          ```bash
          $ echo HEROKU_APP_NAME=my-heroku-app > .env.development
          ```

    - For deployment all variables in `.env` should be set in the deployed
      environment. For example:

          ```bash
          $ heroku config:set HEROKU_APP_NAME=my-heroku-app
          ```

1. Set up your database.

    ```bash
    $ cp config/database.example.yml config/database.yml
    $ rake db:setup
    ```

1. Run the specs.

    ```bash
    $ rspec
    ```

1. [Register your oAuth application](https://github.com/G5/g5_authenticatable#registering-your-oauth-application)

1. [Set oAuth Enviroment Variables](https://github.com/G5/g5_authenticatable#environment-variables)

1. Ensure you have [redis](http://redis.io/) in stalled and started.

1. Start the application.

    ```bash
    $ foreman start -f Procfile.dev
    ```


### Client Location Deployment

1. [Get your AWS S3 credentials ready — for the client's assets](https://console.aws.amazon.com/s3)

1. Set ENV variables. See `.env`.

  * if you have issues connecting to S3 (SocketError: getaddrinfo: nodename nor
    servname provided, or not known) make sure [your region is
    correct](http://docs.aws.amazon.com/general/latest/gr/rande.html)


## CSS Naming Conventions

Most CSS will go inside the modules folder. A module is simply a reusable chunk
of CSS. To create a new module do the following:

1. Create a new file inside the modules folder. It should start with an
   underscore and contain the module name. Example: `_panel.css.scss`
1. The module name is the base class, which contains the basic styles for the
   module. Example: `.panel`
1. If there are multiple words in the base class, use dashes. Example:
   `.my-panel`
1. Any component, or part, of the module is a sub-module. The class should be
   the module name, a dash, and the sub-module. Example: `.panel-title`,
   `.panel-footer`
1. For any alternate styles of the module the class should be module name, two
   dashes, and the alternate style name. Example: `.panel--b`, `.panel--large`


## Client Location Sites

- `app/views/layouts/web_template.html.erb` is the layout file
- `app/views/web_templates/show.html.erb` is used to render each page
- `app/assets/stylesheets/web_template.scss` is for __preview mode only__
- `app/assets/javascripts/web_template.js.coffee` is for __preview mode only__
- `app/views/web_templates/stylesheets.scss` is for preview & deployed mode
- `public/javascripts/` if for preview & deployed mode


## Authors

  * Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
  * Bookis Smuin / [@bookis](https://github.com/bookis)
  * Chris Stringer / [@jcstringer](https://github.com/jcstringer)
  * Michael Mitchell / [@variousred](https://github.com/variousred)
  * Jessica Dillon / [@jessicard](https://github.com/jessicard)
  * Chad Crissman / [@crissmancd](https://github.com/crissmancd)
  * Brian Bauer / [@bbauer](https://github.com/bbauer)
  * Levi Brown / [@levibrown](https://github.com/levibrown)


## Contributing

1. Fork it
1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/g5-content-management-system/issues).


## Specs

```bash
$ rspec
```


### Deployment Specs

1. Set deployment ENV variables in `.env.test` to your personal account.
   Account must be
   [verified](https://devcenter.heroku.com/articles/account-verification).

    - `HEROKU_API_KEY`
    - `HEROKU_USERNAME`
    - `ID_RSA` - See [this dotenv
      issue](https://github.com/bkeepers/dotenv/issues/21) for formatting.

1. Deployment specs do not run by default. To run them:

    ```bash
    $ rspec -t type:deployment
    ```


## License

Copyright (c) 2013 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
