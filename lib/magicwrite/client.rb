module MagicWrite
  class Client
    include MagicWrite::HTTP

    CONFIG_KEYS = %i[
      access_token
      uri_base
      request_timeout
      extra_headers
    ].freeze
    attr_reader(*CONFIG_KEYS)

    def initialize(config = {})
      CONFIG_KEYS.each do |key|
        instance_variable_set("@#{key}", config[key] || MagicWrite.configuration.send(key))
      end
    end

    def agents
      @agents ||= MagicWrite::Agents.new(client: self)
    end

    def companies
      @companies ||= MagicWrite::Companies.new(client: self)
    end

    def completions
      @completions ||= MagicWrite::Completions.new(client: self)
    end

    def ingestions
      @ingestions ||= MagicWrite::Ingestions.new(client: self)
    end

    def memberships
      @memberships ||= MagicWrite::Memberships.new(client: self)
    end

    def session
      get(path: '/session')
    end
  end
end
