module MagicWrite
  class Agents
    def initialize(access_token: nil)
      MagicWrite.configuration.access_token = access_token if access_token
    end

    def list(parameters: {})
      MagicWrite::Client.get(path: '/agents', parameters: parameters)
    end

    def create(parameters: {})
      MagicWrite::Client.json_post(path: '/agents', parameters: parameters)
    end

    def retrieve(id:)
      MagicWrite::Client.get(path: "/agents/#{id}")
    end

    def update(id:, parameters: {})
      MagicWrite::Client.json_put(path: "/agents/#{id}", parameters: parameters)
    end

    def delete(id:)
      MagicWrite::Client.delete(path: "/agents/#{id}")
    end

    def public_list(company_id:, parameters: {})
      MagicWrite::Client.get(path: "/agents/#{company_id}", parameters: parameters)
    end

    def public_retrieve(company_id:, agent_id:)
      MagicWrite::Client.get(path: "/agents/#{company_id}/#{agent_id}")
    end

    def public_create(company_id:, agent_id:, parameters: {})
      MagicWrite::Client.json_post(path: "/agents/#{company_id}/#{agent_id}", parameters: parameters)
    end
  end
end
