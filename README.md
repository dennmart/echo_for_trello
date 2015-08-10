# Echo For Trello

Echo For Trello is a web application to allow [Trello](https://trello.com/) users to set recurring cards at a specific interval via the Trello API. Cards will be repeated daily, weekly or monthly.

To see Echo For Trello in action, go to https://echofortrello.com/.

## Requirements

Echo For Trello is a Ruby on Rails application, so Ruby is required. I prefer [rbenv](https://github.com/sstephenson/rbenv) for setting up Ruby. The app has been developed and running in production using Ruby 2.2.

## Development Setup

* Install all required gems with `bundle install` in the root directory.
* Make sure to set up the Trello key (`TRELLO_KEY`) and secret (`TRELLO_SECRET`) as environment variables (see next section for more info on obtaining this information).
* Start up a Rails server with `rails s`.
* For asynchronous background processes, Echo For Trello uses [Sidekiq](http://sidekiq.org/). You can start the Sidekiq workers by running `sidekiq`.
* There are specs covering most of the functionality, so run `rake spec` if you're doing any development work.

## Environment Variables

To communicate with the Trello API, you must set your Trello Developer API key and secret as environment variables. You can generate these keys at https://trello.com/1/appKey/generate.

The environment variables needed to be set are:

* `TRELLO_KEY`
* `TRELLO_SECRET`

## Contribute

This project is open-source, so all contributions are welcome! The following is a good guideline for contribution:

* Fork the repo on GitHub.
* Create a branch on your forked repo that will contain your changes.
* Hack away on your branch.
* Push the branch to GitHub.
* Send me a pull request for your branch.
