require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hw8
  class Application < Rails::Application
    RSpotify::authenticate(Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret)
  end
end
