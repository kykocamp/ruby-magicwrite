RSpec.describe MagicWrite::Agents do
  let(:client) { MagicWrite::Client.new }
  let(:agents) { described_class.new(client: client) }

  describe '#list' do
    subject { agents.list }

    let(:cassette) { 'agents list' }

    it 'succeeds' do
      VCR.use_cassette(cassette) do
        expect(subject['data'].count).to eq 1
        expect(subject.dig('data', 0, 'name')).to eq 'Agente 001'
      end
    end
  end

  describe '#create' do
    subject { agents.create(parameters: parameters) }

    let(:cassette) { 'agents create' }
    let(:parameters) { { name: 'Agent 002' } }

    it 'succeeds' do
      VCR.use_cassette(cassette) do
        expect(subject['agentID']).to be_a(String)
        expect(subject['companyID']).to be_a(String)
        expect(subject['name']).to eq 'Agent 002'
        expect(subject['status']).to eq 'draft'
      end
    end
  end
end
