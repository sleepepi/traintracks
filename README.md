# Training Grant

[![Build Status](https://travis-ci.org/remomueller/training_grant.png?branch=master)](https://travis-ci.org/remomueller/training_grant)
[![Dependency Status](https://gemnasium.com/remomueller/training_grant.png)](https://gemnasium.com/remomueller/training_grant)
[![Code Climate](https://codeclimate.com/github/remomueller/training_grant.png)](https://codeclimate.com/github/remomueller/training_grant)

Training Grant Management Application that manages new applicants, trainees, and preceptors over a 10-year time period. Using Rails 4.0+ and Ruby 2.0.0+.

## Installation

[Prerequisites Install Guide](https://github.com/remomueller/documentation): Instructions for installing prerequisites like Ruby, Git, JavaScript compiler, etc.

Once you have the prerequisites in place, you can proceed to install bundler which will handle most of the remaining dependencies.

```console
gem install bundler
```

This README assumes the following installation directory: `/var/www/training_grant`

```console
cd /var/www

git clone git://github.com/remomueller/training_grant.git

cd training_grant

bundle install
```

Install default configuration files for database connection, email server connection, server url, and application name.

```console
ruby lib/initial_setup.rb

bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake assets:precompile
```

Run Rails Server (or use Apache or nginx)

```console
rails s -p80
```

Open a browser and go to: [http://localhost](http://localhost)

All done!

## Setting up Seminar Reminder Emails

Edit Cron Jobs `sudo crontab -e` to run the task `lib/tasks/seminar_reminder_email.rake`

```console
0 2 * * * source /etc/profile.d/rvm.sh && cd /var/www/training_grant && /usr/local/rvm/gems/ruby-2.0.0-p0/bin/bundle exec rake seminar_reminder_email RAILS_ENV=production
```

## Contributing to Training Grant

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright [![Creative Commons 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png)](http://creativecommons.org/licenses/by-nc-sa/3.0)

Copyright (c) 2013 Remo Mueller. See [LICENSE](https://github.com/remomueller/training_grant/blob/master/LICENSE) for further details.
