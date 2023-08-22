RSpec.describe MagicWrite::Client do
  context 'with clients with different access tokens' do
    before do
      MagicWrite.configure do |config|
        config.extra_headers = { 'test' => 'X-Default' }
      end
    end

    after do
      MagicWrite.configure do |config|
        config.extra_headers = nil
      end
    end

    let!(:c0) { MagicWrite::Client.new }
    let!(:c1) do
      MagicWrite::Client.new(
        access_token: 'access_token1',
        request_timeout: 60,
        uri_base: 'https://oai.hconeai.com/',
        extra_headers: { 'test' => 'X-Test' }
      )
    end
    let!(:c2) do
      MagicWrite::Client.new(
        access_token: 'access_token2',
        request_timeout: 1,
        uri_base: 'https://example.com/'
      )
    end

    it 'does not confuse the clients' do
      expect(c0.access_token).to eq(ENV.fetch('MAGICWRITE_ACCESS_TOKEN', 'dummy-token'))
      expect(c0.request_timeout).to eq(MagicWrite::Configuration::DEFAULT_REQUEST_TIMEOUT)
      expect(c0.uri_base).to eq(MagicWrite::Configuration::DEFAULT_URI_BASE)
      expect(c0.send(:headers).values).to include("Bearer #{c0.access_token}")
      expect(c0.send(:conn).options.timeout).to eq(MagicWrite::Configuration::DEFAULT_REQUEST_TIMEOUT)
      expect(c0.send(:uri, path: '')).to include(MagicWrite::Configuration::DEFAULT_URI_BASE)
      expect(c0.send(:headers).values).to include('X-Default')
      expect(c0.send(:headers).values).not_to include('X-Test')

      expect(c1.access_token).to eq('access_token1')
      expect(c1.request_timeout).to eq(60)
      expect(c1.uri_base).to eq('https://oai.hconeai.com/')
      expect(c1.send(:headers).values).to include("Bearer #{c1.access_token}")
      expect(c1.send(:conn).options.timeout).to eq(60)
      expect(c1.send(:uri, path: '')).to include('https://oai.hconeai.com/')
      expect(c1.send(:headers).values).not_to include('X-Default')
      expect(c1.send(:headers).values).to include('X-Test')

      expect(c2.access_token).to eq('access_token2')
      expect(c2.request_timeout).to eq(1)
      expect(c2.uri_base).to eq('https://example.com/')
      expect(c2.send(:headers).values).to include("Bearer #{c2.access_token}")
      expect(c2.send(:conn).options.timeout).to eq(1)
      expect(c2.send(:uri, path: '')).to include('https://example.com/')
      expect(c2.send(:headers).values).to include('X-Default')
      expect(c2.send(:headers).values).not_to include('X-Test')
    end

    context 'hitting other classes' do
      after do
        c0.agents.list
        c1.agents.list
        c2.agents.list

        c0.companies.retrieve
        c1.companies.retrieve
        c2.companies.retrieve

        c0.ingestions.list
        c1.ingestions.list
        c2.ingestions.list

        c0.memberships.user
        c1.memberships.user
        c2.memberships.user
      end

      it 'does not confuse the clients' do
        expect(c0).to receive(:get).with(parameters: {}, path: '/agents').once
        expect(c1).to receive(:get).with(parameters: {}, path: '/agents').once
        expect(c2).to receive(:get).with(parameters: {}, path: '/agents').once

        expect(c0).to receive(:get).with(path: '/companies/current').once
        expect(c1).to receive(:get).with(path: '/companies/current').once
        expect(c2).to receive(:get).with(path: '/companies/current').once

        expect(c0).to receive(:get).with(parameters: {}, path: '/ingestions').once
        expect(c1).to receive(:get).with(parameters: {}, path: '/ingestions').once
        expect(c2).to receive(:get).with(parameters: {}, path: '/ingestions').once

        expect(c0).to receive(:get).with(path: '/memberships/user').once
        expect(c1).to receive(:get).with(path: '/memberships/user').once
        expect(c2).to receive(:get).with(path: '/memberships/user').once
      end
    end
  end
end
