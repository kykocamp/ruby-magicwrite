module MagicWrite
  class Ingestions
    def initialize(client:)
      @client = client
    end

    def list(parameters: {})
      client.get(path: '/ingestions', parameters: parameters)
    end

    def create(parameters: {})
      client.json_post(path: '/ingestions', parameters: parameters)
    end

    def retrieve(id:)
      client.get(path: "/ingestions/#{id}")
    end

    def delete(id:)
      client.delete(path: "/ingestions/#{id}")
    end

    private

    attr_reader :client
  end
end
