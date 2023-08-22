module MagicWrite
  class Completions
    def initialize(client:)
      @client = client
    end

    def execute(parameters: {})
      client.json_post(path: '/completions', parameters: parameters)
    end

    def retrieve(id:, parameters: {})
      client.get(path: "/completions/#{id}", parameters: parameters)
    end

    def create(id:, parameters: {})
      client.json_post(path: "/completions/#{id}", parameters: parameters)
    end

    def delete(id:, completion_id:)
      client.delete(path: "/completions/#{id}/#{completion_id}")
    end

    private

    attr_reader :client
  end
end
