require 'faraday'
require 'faraday/multipart'

require_relative 'magicwrite/http'
require_relative 'magicwrite/client'
require_relative 'magicwrite/agents'
require_relative 'magicwrite/companies'
require_relative 'magicwrite/completions'
require_relative 'magicwrite/error'
require_relative 'magicwrite/error_handler'
require_relative 'magicwrite/ingestions'
require_relative 'magicwrite/version'

module MagicWrite
  class ConfigurationError < Error; end

  class Configuration
    attr_writer :access_token
    attr_accessor :uri_base, :request_timeout

    DEFAULT_URI_BASE = 'https://api.magicwrite.ai/rest/'.freeze
    DEFAULT_REQUEST_TIMEOUT = 120

    def initialize
      @access_token = nil
      @uri_base = DEFAULT_URI_BASE
      @request_timeout = DEFAULT_REQUEST_TIMEOUT
    end

    def access_token
      return @access_token if @access_token

      error_text = 'MagicWrite access token missing! See https://github.com/kykocamp/ruby-magicwrite#usage'
      raise ConfigurationError, error_text
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= MagicWrite::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
