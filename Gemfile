source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5'
gem 'sprockets-rails', '~> 2.3'
gem 'pg'
gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'slim-rails', '~> 3.0'
gem 'omniauth', '~> 1.2'
gem 'omniauth-trello', '0.0.4'
gem 'httparty', '~> 0.13.3'
gem 'high_voltage', '~> 2.4'
gem 'hogan_assets', '~> 1.6'
gem 'kaminari', '~> 0.16'
gem 'sidekiq', '~> 4.0'
gem 'sinatra', '~> 1.4', require: false
gem 'whenever', '~> 0.9', require: false
gem 'airbrake', '~> 5.0'
gem 'puma', '~> 2.14'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'pry-rails', '~> 0.3'
  gem 'web-console', '~> 3.0'
end

group :development, :test do
  gem 'byebug'
  gem 'spring'
  gem 'rspec-rails', '~> 3.2'
  gem 'factory_girl_rails', '~> 4.5'
end

group :test do
  gem 'webmock'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'timecop', '~> 0.7'
end
