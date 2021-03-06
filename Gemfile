source 'https://rubygems.org'

ruby "2.2.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Haml as templating engine
gem 'haml-rails', '~> 0.9'

# Simple Form is flexible and powerful tool to create forms
gem 'simple_form'

# Use Nokogiri for html/xml parsing
gem 'nokogiri'

# Use Sorcery for authorization
gem 'sorcery'

# Use Paperclip for file upload
gem 'paperclip', '~> 4.3'

# Use AWS for files storage
gem 'aws-sdk', '<2'

# Use Levenshtein-ffi for fast distance computation between words
gem 'levenshtein-ffi', require: 'levenshtein'

# Use Whenever for writing cron jobs
gem 'whenever', require: false

# HTTPAcceptLanguage helps to detect the users preferred language
gem 'http_accept_language'

# Use Rollbar for exception notifications
gem 'rollbar', '~> 2.1.1'

# Use NewRelic for application monitoring
gem 'newrelic_rpm'

# gem 'rails_12factor', group: :production
gem 'dotenv-rails'

group :development, :test do
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
end

group :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'faker'
  gem 'codeclimate-test-reporter', require: nil
end

group :production do
  gem 'puma'
end
