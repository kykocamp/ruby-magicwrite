module MagicWrite
  class Completions
    def initialize(access_token: nil)
      MagicWrite.configuration.access_token = access_token if access_token
    end

    def execute(parameters: {})
      MagicWrite::Client.json_post(path: '/completions', parameters: parameters)
    end

    def retrieve(id:, parameters: {})
      MagicWrite::Client.get(path: "/completions/#{id}", parameters: parameters)
    end

    def create(id:, parameters: {})
      MagicWrite::Client.json_post(path: "/completions/#{id}", parameters: parameters)
    end

    def delete(id:, completion_id:)
      MagicWrite::Client.delete(path: "/completions/#{id}/#{completion_id}")
    end
  end
end
