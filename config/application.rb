require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Congaree
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Eastern Time (US & Canada)'
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = false
    config.active_job.queue_adapter = :sidekiq
    config.nav_lynx.selected_class = 'active'
    config.assets.precompile += %w[email.css]

    config.cache_store = :memory_store
    config.after_initialize do
      Broadcaster::ClientVersion.broadcast(ENV.fetch('CLIENT_VERSION').to_i)
    end
  end
end
