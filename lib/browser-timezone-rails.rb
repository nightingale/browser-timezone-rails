require "browser-timezone-rails/engine"
require 'jquery-rails'
require 'jquery-cookie-rails'
require 'jstz-rails'

module BrowserTimezoneRails
  module TimezoneControllerSetup
    def self.included(base)
      base.send(:prepend_around_action, :set_time_zone)
    end

    private

    def set_time_zone(&action)
      # Use existing methods to simplify filter
      puts "TIMEZONE HEADER: " + request.headers.env["timezone"].to_s
      Time.use_zone(browser_timezone.presence || Time.zone, &action || request.headers.env["timezone"])
    end

    def browser_timezone
      cookies["browser.timezone"]
    end
  end

  class Railtie < Rails::Engine
    initializer "browser_timezone_rails.controller" do
      ActiveSupport.on_load(:action_controller) do
        include BrowserTimezoneRails::TimezoneControllerSetup
      end
    end
  end
end
