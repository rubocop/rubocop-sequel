# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ['Timothée Peignier']
  gem.email         = ['timothee.peignier@tryphon.org']
  gem.description   = 'Code style checking for Sequel'
  gem.summary       = 'A plugin for the RuboCop code style & linting tool.'
  gem.homepage      = 'http://rubygems.org/gems/rubocop-sequel'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'rubocop-sequel'
  gem.require_paths = ['lib']
  gem.version       = '0.0.1'

  gem.add_runtime_dependency 'rubocop', '~> 0.46', '>= 0.46'

  gem.add_development_dependency 'sequel', '~> 4.41', '>= 4.41.0'
  gem.add_development_dependency 'rspec', '~> 3.5', '>= 3.5.0'
  gem.add_development_dependency 'simplecov', '~> 0.12'
  gem.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.12'
end
