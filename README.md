# README

- install mysql for your system (tested on 5.6.44)

- install ruby 2.3.3

- `bundle install`

- add user and password in `config/database.yml` (or use an environment variable)

- Setup the database: `RAILS_ENV=production rake db:create db:schema:load`

- Populate the database.  IMPORTANT NOTE: This will require a very large amount of space and a long duration to complete.  Estimated at over 600gb and over 24 hours, but could be longer.  To proceed `RAILS_ENV=production rake users:populate`

- `rake assets:precompile`

- Start the server `RAILS_ENV=production rails s`
