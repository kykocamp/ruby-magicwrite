module MagicWrite
  class Ingestions
    def initialize(access_token: nil)
      MagicWrite.configuration.access_token = access_token if access_token
    end

    def list(parameters: {})
      MagicWrite::Client.get(path: '/ingestions', parameters: parameters)
    end

    def create(parameters: {})
      MagicWrite::Client.json_post(path: '/ingestions', parameters: parameters)
    end

    def retrieve(id:)
      MagicWrite::Client.get(path: "/ingestions/#{id}")
    end

    def delete(id:)
      MagicWrite::Client.delete(path: "/ingestions/#{id}")
    end
  end
end
