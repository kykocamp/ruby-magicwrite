module MagicWrite
  class Companies
    def initialize(access_token: nil)
      MagicWrite.configuration.access_token = access_token if access_token
    end

    def create(parameters: {})
      MagicWrite::Client.json_post(path: '/companies', parameters: parameters)
    end

    def retrieve
      MagicWrite::Client.get(path: '/companies/current')
    end

    def update(parameters: {})
      MagicWrite::Client.json_put(path: '/companies/current', parameters: parameters)
    end
  end
end
