require_relative 'boot'
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 5.2
    config.time_zone = 'Tokyo'

    config.generators do |g|
      g.test_framework :rspec,
      controller_specs: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
    end
  end
end
