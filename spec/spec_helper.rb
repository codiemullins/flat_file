require 'codeclimate-test-reporter'
require 'simplecov'
require 'coveralls'

if ENV["TRAVIS"] == 'true'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end
SimpleCov.start

require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'lib', 'flat_file'))

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
