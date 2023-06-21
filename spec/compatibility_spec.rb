RSpec.describe 'compatibility' do
  context 'for moved constants' do
    describe '::Ruby::MagicWrite::VERSION' do
      it 'is mapped to ::MagicWrite::VERSION' do
        expect(Ruby::MagicWrite::VERSION).to eq(MagicWrite::VERSION)
      end
    end

    describe '::Ruby::MagicWrite::Error' do
      it 'is mapped to ::MagicWrite::Error' do
        expect(Ruby::MagicWrite::Error).to eq(MagicWrite::Error)
        expect(Ruby::MagicWrite::Error.new).to be_a(MagicWrite::Error)
        expect(MagicWrite::Error.new).to be_a(Ruby::MagicWrite::Error)
      end
    end

    describe '::Ruby::MagicWrite::ConfigurationError' do
      it 'is mapped to ::MagicWrite::ConfigurationError' do
        expect(Ruby::MagicWrite::ConfigurationError).to eq(MagicWrite::ConfigurationError)
        expect(Ruby::MagicWrite::ConfigurationError.new).to be_a(MagicWrite::ConfigurationError)
        expect(MagicWrite::ConfigurationError.new).to be_a(Ruby::MagicWrite::ConfigurationError)
      end
    end

    describe '::Ruby::MagicWrite::Configuration' do
      it 'is mapped to ::MagicWrite::Configuration' do
        expect(Ruby::MagicWrite::Configuration).to eq(MagicWrite::Configuration)
        expect(Ruby::MagicWrite::Configuration.new).to be_a(MagicWrite::Configuration)
        expect(MagicWrite::Configuration.new).to be_a(Ruby::MagicWrite::Configuration)
      end
    end
  end
end
