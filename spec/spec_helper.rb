require 'bundler/setup'
require 'dotenv/load'
require 'magicwrite'
require 'magicwrite/compatibility'
require 'vcr'

Dir[File.expand_path('spec/support/**/*.rb')].sort.each { |f| require f }

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.default_cassette_options = {
    record: ENV.fetch('MAGICWRITE_ACCESS_TOKEN', nil) ? :all : :new_episodes,
    match_requests_on: [:method, :uri, VCRMultipartMatcher.new]
  }
  c.filter_sensitive_data('<MAGICWRITE_ACCESS_TOKEN>') { MagicWrite.configuration.access_token }
end

RSpec.configure do |c|
  # Enable flags like --only-failures and --next-failure
  c.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  c.disable_monkey_patching!

  c.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  if ENV.fetch('MAGICWRITE_ACCESS_TOKEN', nil)
    warning = 'WARNING! Specs are hitting the MagicWrite API using your MAGICWRITE_ACCESS_TOKEN!'.freeze
    warning = RSpec::Core::Formatters::ConsoleCodes.wrap(warning, :bold_red)

    c.before(:suite) { RSpec.configuration.reporter.message(warning) }
    c.after(:suite) { RSpec.configuration.reporter.message(warning) }
  end

  c.before(:all) do
    MagicWrite.configure do |config|
      config.access_token = ENV.fetch('MAGICWRITE_ACCESS_TOKEN', 'dummy-token')
    end
  end
end

RSPEC_ROOT = File.dirname __FILE__
