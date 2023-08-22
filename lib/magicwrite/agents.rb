module MagicWrite
  class Agents
    def initialize(client:)
      @client = client
    end

    def list(parameters: {})
      client.get(path: '/agents', parameters: parameters)
    end

    def create(parameters: {})
      client.json_post(path: '/agents', parameters: parameters)
    end

    def retrieve(id:)
      client.get(path: "/agents/#{id}")
    end

    def update(id:, parameters: {})
      client.json_put(path: "/agents/#{id}", parameters: parameters)
    end

    def delete(id:)
      client.delete(path: "/agents/#{id}")
    end

    def public_list(company_id:, parameters: {})
      client.get(path: "/agents/#{company_id}", parameters: parameters)
    end

    def public_retrieve(company_id:, agent_id:)
      client.get(path: "/agents/#{company_id}/#{agent_id}")
    end

    def public_create(company_id:, agent_id:, parameters: {})
      client.json_post(path: "/agents/#{company_id}/#{agent_id}", parameters: parameters)
    end

    private

    attr_reader :client
  end
end
