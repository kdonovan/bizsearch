source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem "autoprefixer-rails"
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'bootstrap-sass'
gem 'haml-rails'
gem 'high_voltage'
gem 'pg', '~> 0.18.4'
gem 'simple_form', '~> 3.2.1'
gem 'state_machine', '~> 1.2.0'
gem 'eel', '~> 1.0.3'
gem 'env'

# TODO: upgrade to stable 4.0
gem 'devise', '~> 4.0.0.rc1'

gem 'searchbot', path: "../searchbot"
gem 'sucker_punch' # TODO: replace with sidekiq

gem 'puma'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'better_errors'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'awesome_print'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end
