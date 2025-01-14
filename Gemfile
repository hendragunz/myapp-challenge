source "https://rubygems.org"
ruby "3.3.6"

# Core Gems
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "slim-rails"
gem 'devise', '~> 4.9', '>= 4.9.4'
gem "redis", ">= 4.0.1"
gem 'sidekiq', '~> 7.3', '>= 7.3.7'
gem 'sidekiq-throttled', '~> 1.5', '>= 1.5.2'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"


gem 'httparty'
gem 'nokogiri'
gem "selenium-webdriver"


group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'dotenv', groups: [:development, :test]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'annotate'
  gem "awesome_print"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
end

gem "tailwindcss-rails", "~> 3.1"

gem "grape", "~> 2.2"
