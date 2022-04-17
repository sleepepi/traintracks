# Train Tracks

[![Build Status](https://travis-ci.com/sleepepi/traintracks.svg?branch=master)](https://travis-ci.com/sleepepi/traintracks)
[![Code Climate](https://codeclimate.com/github/sleepepi/traintracks/badges/gpa.svg)](https://codeclimate.com/github/sleepepi/traintracks)

Train Tracks manages new applicants, trainees, and preceptors over a 15-year
time period. Using Rails 6.0+ and Ruby 2.6+.

## Installation

[Prerequisites Install Guide](https://github.com/remomueller/documentation):
Instructions for installing prerequisites like Ruby, Git, JavaScript compiler,
etc.

Once you have the prerequisites in place, you can proceed to install bundler
which will handle most of the remaining dependencies.

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

Install default configuration files for database connection, email server
connection, server url, and application name.

```
ruby lib/initial_setup.rb

rails db:migrate RAILS_ENV=production

rails assets:precompile RAILS_ENV=production
```

Run Rails Server (or use Apache or nginx)

```
rails s -p80
```

Open a browser and go to: [http://localhost](http://localhost)

All done!

## Setting up Seminar Reminder Emails

Edit Cron Jobs `sudo crontab -e` to run the task
`lib/tasks/seminar_reminder_email.rake`

```
SHELL=/bin/bash
0 2 * * * source /etc/profile.d/rvm.sh && cd /var/www/traintracks && rvm 3.0.2 && rails seminar_reminder_email RAILS_ENV=production
```

## Contributing to Train Tracks

- Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a
  future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to
  have your own version, or is otherwise necessary, that is fine, but please
  isolate to its own commit so I can cherry-pick around it.

## License

Train Tracks is released under the [MIT License](http://www.opensource.org/licenses/MIT).
