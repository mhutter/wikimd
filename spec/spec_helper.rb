ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start

# Fixture repo is included in the GIT repository
FIXTURE_REPO_PATH = File.expand_path('../fixtures/repo', __FILE__)
# Temp-Repo will be deleted before tests!
TMP_REPO_PATH = File.expand_path('../../tmp/test_repo', __FILE__)
# remember the original PWD
ORIGINAL_PWD = Dir.pwd

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
# See .rspec
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4.
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Will default to `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options.
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # set to any number to enable profiling
  config.profile_examples = false

  config.order = :random
  Kernel.srand config.seed
end
