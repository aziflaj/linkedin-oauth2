require 'oauth2'

require_relative 'linked_in/errors'
require_relative 'linked_in/raise_error'
require_relative 'linked_in/version'
require_relative 'linked_in/configuration'

# Responsible for all authentication
# LinkedIn::OAuth2 inherits from OAuth2::Client
require_relative 'linked_in/oauth2'

# Coerces LinkedIn JSON to a nice Ruby hash
# LinkedIn::Mash inherits from Hashie::Mash
require 'hashie'
require_relative 'linked_in/mash'

# Wraps a LinkedIn-specific API connection
# LinkedIn::Connection inherits from Faraday::Connection
require 'faraday'
require_relative 'linked_in/connection'

# Data object to wrap API access token
require_relative 'linked_in/access_token'

# Endpoints inherit from APIResource
require_relative 'linked_in/api_resource'

# All of the endpoints
require_relative 'linked_in/jobs'
require_relative 'linked_in/people'
require_relative 'linked_in/search'
require_relative 'linked_in/groups'
require_relative 'linked_in/companies'
require_relative 'linked_in/communications'
require_relative 'linked_in/share_and_social_stream'

# The primary API object that makes requests.
# It composes in all of the endpoints
require_relative 'linked_in/api'

module LinkedIn
  @config = Configuration.new

  class << self
    attr_accessor :config
  end

  def self.configure
    yield self.config
  end
end
