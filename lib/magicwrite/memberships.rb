module MagicWrite
  class Memberships
    def initialize(access_token: nil)
      MagicWrite.configuration.access_token = access_token if access_token
    end

    def user
      MagicWrite::Client.get(path: '/memberships/user')
    end

    def company
      MagicWrite::Client.get(path: '/memberships/company')
    end
  end
end
