# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.authors       = ['Timothée Peignier']
  gem.email         = ['timothee.peignier@tryphon.org']
  gem.description   = 'Code style checking for Sequel'
  gem.summary       = 'A Sequel plugin for RuboCop'
  gem.homepage      = 'https://github.com/rubocop-hq/rubocop-sequel'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'rubocop-sequel'
  gem.require_paths = ['lib']
  gem.version       = '0.1.0'

  gem.required_ruby_version = '~> 2.4'

  gem.add_runtime_dependency 'rubocop', '~> 1.0'

  gem.add_development_dependency 'rake', '~> 12.3.0'
  gem.add_development_dependency 'rspec', '~> 3.7'
  gem.add_development_dependency 'rubocop-rspec', '~> 2.0'
  gem.add_development_dependency 'sequel', '~> 4.49'
  gem.add_development_dependency 'simplecov', '~> 0.16'
  gem.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.12'
end
