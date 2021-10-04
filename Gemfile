source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.9'

gem 'rails', '~> 5.2.6'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'unicorn'
gem 'unicorn-worker-killer'
gem 'devise'
gem 'jquery-rails'
gem 'carrierwave'
gem 'fog-aws'
gem 'virtus'
gem 'kaminari'
gem 'rails-i18n', '~> 5.1'
gem 'faker'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
