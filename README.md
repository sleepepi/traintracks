# Train Tracks

[![Build Status](https://travis-ci.org/sleepepi/traintracks.svg?branch=master)](https://travis-ci.org/sleepepi/traintracks)
[![Dependency Status](https://gemnasium.com/sleepepi/traintracks.svg)](https://gemnasium.com/sleepepi/traintracks)
[![Code Climate](https://codeclimate.com/github/sleepepi/traintracks/badges/gpa.svg)](https://codeclimate.com/github/sleepepi/traintracks)

Train Tracks manages new applicants, trainees, and preceptors over a 10-year time period. Using Rails 4.2+ and Ruby 2.3+.

## Installation

[Prerequisites Install Guide](https://github.com/remomueller/documentation): Instructions for installing prerequisites like Ruby, Git, JavaScript compiler, etc.

Once you have the prerequisites in place, you can proceed to install bundler which will handle most of the remaining dependencies.

```
gem install bundler
```

This README assumes the following installation directory: `/var/www/traintracks`

```
cd /var/www

git clone https://github.com/sleepepi/traintracks.git

cd traintracks

bundle install
```

Install default configuration files for database connection, email server connection, server url, and application name.

```
ruby lib/initial_setup.rb

bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake assets:precompile RAILS_ENV=production
```

Run Rails Server (or use Apache or nginx)

```
rails s -p80
```

Open a browser and go to: [http://localhost](http://localhost)

All done!

## Setting up Seminar Reminder Emails

Edit Cron Jobs `sudo crontab -e` to run the task `lib/tasks/seminar_reminder_email.rake`

```
SHELL=/bin/bash
0 2 * * * source /etc/profile.d/rvm.sh && cd /var/www/traintracks && /usr/local/rvm/gems/ruby-2.3.0/bin/bundle exec rake seminar_reminder_email RAILS_ENV=production
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

Copyright (c) 2015 Remo Mueller. See [LICENSE](https://github.com/sleepepi/traintracks/blob/master/LICENSE) for further details.
