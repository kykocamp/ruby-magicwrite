module MagicWrite
  class Client
    extend MagicWrite::HTTP

    def initialize(access_token: nil, uri_base: nil, request_timeout: nil)
      MagicWrite.configuration.access_token = access_token if access_token
      MagicWrite.configuration.uri_base = uri_base if uri_base
      MagicWrite.configuration.request_timeout = request_timeout if request_timeout
    end

    def agents
      @agents ||= MagicWrite::Agents.new
    end

    def companies
      @companies ||= MagicWrite::Companies.new
    end

    def completions
      @completions ||= MagicWrite::Completions.new
    end

    def ingestions
      @ingestions ||= MagicWrite::Ingestions.new
    end

    def session
      MagicWrite::Client.get(path: '/session')
    end
  end
end
