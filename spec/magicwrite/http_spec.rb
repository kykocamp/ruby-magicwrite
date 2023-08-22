RSpec.describe MagicWrite::HTTP do
  describe 'with an aggressive timeout' do
    let(:timeout_errors) { [Faraday::ConnectionFailed, Faraday::TimeoutError] }
    let(:timeout) { 0 }

    before do
      VCR.turn_off!
      WebMock.allow_net_connect!
      MagicWrite.configuration.request_timeout = timeout
    end

    after do
      VCR.turn_on!
      WebMock.disable_net_connect!
      MagicWrite.configuration.request_timeout = MagicWrite::Configuration::DEFAULT_REQUEST_TIMEOUT
    end

    describe '.get' do
      let(:response) { MagicWrite::Client.new.session }

      it 'times out' do
        expect { response }.to raise_error do |error|
          expect(timeout_errors).to include(error.class)
        end
      end
    end

    describe '.json_post' do
      let(:response) do
        MagicWrite::Client.new.completions.execute(
          parameters: {
            web: true,
            ingestions: false,
            prompt: 'Generate a blog post'
          }
        )
      end

      it 'times out' do
        expect { response }.to raise_error do |error|
          expect(timeout_errors).to include(error.class)
        end
      end
    end

    describe '.json_put' do
      let(:response) do
        MagicWrite::Client.new.agents.update(
          id: '1a',
          parameters: {
            name: 'New agent name'
          }
        )
      end

      it 'times out' do
        expect { response }.to raise_error do |error|
          expect(timeout_errors).to include(error.class)
        end
      end
    end

    describe '.delete' do
      let(:response) do
        MagicWrite::Client.new.agents.delete(id: '1a')
      end

      it 'times out' do
        expect { response }.to raise_error do |error|
          expect(timeout_errors).to include(error.class)
        end
      end
    end

    describe '.to_json' do
      context 'with a jsonl string' do
        let(:body) { "{\"prompt\":\":)\"}\n{\"prompt\":\":(\"}\n" }
        let(:parsed) { MagicWrite::Client.new.send(:to_json, body) }

        it { expect(parsed).to eq([{ 'prompt' => ':)' }, { 'prompt' => ':(' }]) }
      end
    end

    describe '.uri' do
      let(:path) { '/test' }
      let(:uri) { MagicWrite::Client.new.send(:uri, path: path) }
      let(:expected_uri) { 'https://api.magicwrite.ai/rest/test' }

      it { expect(uri).to eq expected_uri }

      context 'uri_base without trailing slash' do
        before { MagicWrite.configuration.uri_base = 'https://api.magicwrite.ai/rest' }
        after { MagicWrite.configuration.uri_base = 'https://api.magicwrite.ai/rest/' }

        it { expect(uri).to eq expected_uri }
      end
    end

    describe '.headers' do
      let(:headers) { MagicWrite::Client.new.send(:headers) }
      let(:expected_headers) do
        {
          'Authorization' => "Bearer #{MagicWrite.configuration.access_token}",
          'Content-Type' => 'application/json'
        }
      end

      it { expect(headers).to eq expected_headers }
    end
  end
end
