module MagicWrite
  class Companies
    def initialize(client:)
      @client = client
    end

    def create(parameters: {})
      client.json_post(path: '/companies', parameters: parameters)
    end

    def retrieve
      client.get(path: '/companies/current')
    end

    def update(parameters: {})
      client.json_put(path: '/companies/current', parameters: parameters)
    end

    private

    attr_reader :client
  end
end
