module MagicWrite
  class Memberships
    def initialize(client:)
      @client = client
    end

    def user
      client.get(path: '/memberships/user')
    end

    def company
      client.get(path: '/memberships/company')
    end

    private

    attr_reader :client
  end
end
