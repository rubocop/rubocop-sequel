# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.authors       = ['Timothée Peignier']
  gem.email         = ['timothee.peignier@tryphon.org']
  gem.description   = 'Code style checking for Sequel'
  gem.summary       = 'A Sequel plugin for the RuboCop code style & linting tool.'
  gem.homepage      = 'https://github.com/rubocop-hq/rubocop-sequel'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'rubocop-sequel'
  gem.require_paths = ['lib']
  gem.version       = '0.0.6'

  gem.add_runtime_dependency 'rubocop', '~> 0.55', '>= 0.55'

  gem.add_development_dependency 'rake', '~> 12.3.0', '>= 12.0.0'
  gem.add_development_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.25.0', '>= 1.25.0'
  gem.add_development_dependency 'sequel', '~> 4.49', '>= 4.49.0'
  gem.add_development_dependency 'simplecov', '~> 0.16'
  gem.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.12'
end
