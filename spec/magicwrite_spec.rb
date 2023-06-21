RSpec.describe MagicWrite do
  it 'has a version number' do
    expect(MagicWrite::VERSION).not_to be nil
  end

  describe '#configure' do
    let(:access_token) { 'abc123' }
    let(:custom_uri_base) { 'ghi789' }
    let(:custom_request_timeout) { 25 }

    before do
      MagicWrite.configure do |config|
        config.access_token = access_token
      end
    end

    it 'returns the config' do
      expect(MagicWrite.configuration.access_token).to eq(access_token)
      expect(MagicWrite.configuration.uri_base).to eq('https://api.magicwrite.ai/rest/')
      expect(MagicWrite.configuration.request_timeout).to eq(120)
    end

    context 'without an access token' do
      let(:access_token) { nil }

      it 'raises an error' do
        expect { MagicWrite::Client.new.session }.to raise_error(MagicWrite::ConfigurationError)
      end
    end

    context 'with custom timeout and uri base' do
      before do
        MagicWrite.configure do |config|
          config.uri_base = custom_uri_base
          config.request_timeout = custom_request_timeout
        end
      end

      it 'returns the config' do
        expect(MagicWrite.configuration.access_token).to eq(access_token)
        expect(MagicWrite.configuration.uri_base).to eq(custom_uri_base)
        expect(MagicWrite.configuration.request_timeout).to eq(custom_request_timeout)
      end
    end
  end
end
