lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flat_file/version'

Gem::Specification.new do |s|
  s.name        = 'flat_file'
  s.version     = FlatFile::VERSION
  s.date        = '2013-08-03'
  s.summary     = 'FlatFile - Parser and Writer'
  s.description = 'DSL Parser/Writer for fixed-width and delimited files'
  s.authors     = ['Codie Mullins', 'TJ Peden']
  s.email       = 'codie.mullins@waterfield.com'
  s.files       = `git ls-files`.split($RS)
  s.test_files = s.files.grep(%r{^(test|spec)/})
  s.require_paths = ['lib']
  s.homepage    = 'http://github.com/codiemullins/flat_file'
  s.license     = 'MIT'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'rspec', '~> 2.14.0'
  s.add_development_dependency 'awesome_print', '~> 1.2.0'
  s.add_development_dependency 'pry', '~> 0.9.12'

end
