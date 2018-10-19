# frozen_string_literal: true

source "https://rubygems.org"

gem "rails",                "5.2.1"

# Database Adapter
gem "mysql2",               "0.5.1"

# Gems used by project
gem "autoprefixer-rails"
gem "bootstrap",            "~> 4.1.3"
gem "carrierwave",          "~> 1.2.2"
gem "devise",               "~> 4.4.3"
gem "figaro",               "~> 1.1.1"
gem "font-awesome-sass",    "~> 5.3.1"
gem "haml",                 "~> 5.0.4"
gem "kaminari",             "~> 1.1.1"

# Rails Defaults
gem "coffee-rails",         "~> 4.2"
gem "sass-rails",           "~> 5.0"
gem "uglifier",             ">= 1.3.0"

gem "jbuilder",             "~> 2.5"
gem "jquery-rails",         "~> 4.3.1"
gem "turbolinks",           "~> 5"

group :development do
  gem "web-console", "~> 3.0"
end

group :test do
  gem "capybara",           "~> 3.0"
  gem "minitest"
  gem "puma"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "simplecov",          "~> 0.16.1", require: false
end
