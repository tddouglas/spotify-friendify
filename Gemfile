source 'https://rubygems.org'

# TODO: Specify the Ruby version (2.4.1)
ruby '2.4.1'

gem 'rails', '5.0.3'
# TODO: Move sqlite gem to the development group
gem 'puma', '3.10.0'
gem 'sass-rails', '5.0.6'
gem 'uglifier', '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks', '5.0.1'
gem 'jbuilder', '2.7.0'
gem 'rspotify', '1.24.0'
gem 'bcrypt', '3.1.11'
gem 'omniauth-spotify'
gem 'bootstrap', '~> 4.0.0.beta'

# TODO: Add a production group and add the pg gem
group :production do
  gem 'pg'
end

group :development, :test do
  gem 'dotenv-rails', '2.2.1'
  gem 'sqlite3', '1.3.13'
  gem 'byebug', '9.0.6', platform: :mri
  gem 'pry', '0.10.4'
  gem 'rspec-rails', '3.6.0'
  gem 'capybara', '2.15.1'
  gem 'database_cleaner', '1.6.1'
  gem 'rubocop', '0.47.1'
  gem 'webmock', '3.1.0'
end

group :development do
  gem 'web-console', '3.5.1'
  gem 'listen', '3.0.8'
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
