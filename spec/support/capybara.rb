require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/email/rspec'

Capybara.server_port = 3001
Capybara.app_host = 'http://localhost:3001'
Capybara.save_and_open_page_path = Dir.pwd

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.before :suite do
    Warden.test_mode!
  end
  config.after :each do
    Warden.test_reset!
  end
end
