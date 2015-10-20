source 'https://rubygems.org'

ruby '2.2.3'
gem 'rails', '4.2.4'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'bcrypt' # Use ActiveModel has_secure_password

gem 'sdoc', '~> 0.4.0', group: :doc

gem 'rets'
gem 'nokogiri'
gem 'httpclient'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# My Gems
# Design
gem 'bootstrap-sass', '~> 3.3.5.1'
gem 'autoprefixer-rails'
gem 'font-awesome-rails', '~> 4.3.0.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.

# Authenticate
gem 'devise', '~> 3.5.1'
gem "cancan"

# Oh the Backend
gem 'puma'
gem 'sidekiq'
gem 'awesome_print', '~> 1.6.1'
gem "rack-timeout"
gem 'paperclip', '~> 4.2.1'
gem 'delayed_paperclip'
gem 'aws-sdk', '< 2.0'
gem "figaro"
gem 'rails_admin', '~> 0.6.8'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'better_errors'
  gem 'byebug'                # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'web-console', '~> 2.0' # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'                # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
end

group :development do
  gem 'habtm_generator'
end
