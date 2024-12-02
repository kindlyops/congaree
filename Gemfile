source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1.0'
gem 'bootstrap', '~> 4.3.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'sprockets', '~> 3.7.2'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'oj'
gem 'lograge'

group :development, :test, :demo do
  gem 'factory_girl_rails', '~> 4.9'
  gem 'faker', '~> 1.6.0'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.2.1'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.6.0'
  gem 'solargraph'
end

group :test do
  gem 'capybara', '~> 3.20.0'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 4.0'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'launchy', '~> 2.4.3'
  gem 'pundit-matchers', '~> 1.6.0'
  gem 'rails-controller-testing'
  gem 'rubocop', '~> 0.67.2'
  gem 'shoulda-matchers', '~> 4.1.0'
  gem 'vcr', '~> 5.0.0'
  gem 'webmock', '~> 3.5.1'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', '~> 3.3.0'
  gem 'bullet', '~> 6.0.1'
  gem 'listen', '~> 3.1.5'
  gem 'meta_request', '~> 0.7.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 3.1.0'
  gem 'foreman'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

gem 'sentry-raven'

# Authentication
gem 'devise', '~> 4.6.2'
gem 'devise_invitable', '~> 1.7.2'

# Authorization
gem 'pundit', git: 'https://github.com/elabs/pundit.git', ref: '58eda659d44a2'

# Impersonation
gem 'aasm', '~> 4.12.1'
gem 'ahoy_email', '~> 1.0.3'
gem 'aws-sdk', '~> 3.0.1'
gem 'browser', '~> 2.5.1'
gem 'charlock_holmes', '~> 0.7.6'
gem 'cocoon', '~> 1.2.14'
gem 'counter_culture', '~> 1.5.1'
gem 'csv_shaper', '~> 1.3.0'
gem 'draper', '~> 3.0.0'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'haml', '~> 5.0.4'
gem 'inline_svg', '~> 1.4.0'
gem 'intercom-rails', '~> 0.3.4'
gem 'json', '~> 2.1.0'
gem 'kaminari', '~> 0.17.0'
gem 'liquid', '~> 4.0.0'
gem 'nav_lynx', '~> 1.1.1'
gem 'nokogiri', '~> 1.10.3'
gem 'paperclip', '~> 6.1.0'
gem 'paranoia', '~> 2.4'
gem 'phony_rails', '~> 0.14.0'
gem 'premailer-rails', '~> 1.9.6'
gem 'puma', '~> 3.12'
gem 'rack-affiliates'
gem 'rails_admin', github: 'sferik/rails_admin', branch: 'master'
gem 'ransack'
gem 'sidekiq', '~> 4.0.0'
gem 'sinatra', '~> 2.0.5'
gem 'slack-notifier', '~> 2.3.2'
gem 'slim-rails', '~> 3.2.0'
gem 'smartystreets_ruby_sdk', github: 'hwhelchel/smartystreets-ruby-sdk', branch: 'rearchitect-gem'
gem 'stripe', '~> 3.15.0'
gem 'stripe_event', '~> 2.2.0'
gem 'twemoji', '~> 3.1.4'
gem 'twilio-ruby', '~> 4.13.0'
gem 'webpacker', '~> 3.4.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-clipboard', '~> 2.0.4'
  gem 'rails-assets-lodash', '~> 4.17.11'
  gem 'rails-assets-popper.js', '~> 1.15.0'
  gem 'rails-assets-ramda', '~> 0.26.0'
  # don't use 4.0.6 or 4.0.7 due to tags focus bug
  # https://github.com/select2/select2/pull/5558
  # https://kindlyops.atlassian.net/browse/CH-83
  gem 'rails-assets-select2', '4.0.5'
  gem 'rails-assets-timepicker', '~> 1.11.15'
end
