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
end
