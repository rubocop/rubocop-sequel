# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.authors       = ['Timothée Peignier']
  gem.email         = ['timothee.peignier@tryphon.org']
  gem.description   = 'Code style checking for Sequel'
  gem.summary       = 'A Sequel plugin for RuboCop'
  gem.homepage      = 'https://github.com/rubocop/rubocop-sequel'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.name          = 'rubocop-sequel'
  gem.require_paths = ['lib']
  gem.version       = '0.3.7'
  gem.metadata['rubygems_mfa_required'] = 'true'

  gem.required_ruby_version = '>= 2.5'

  gem.add_dependency 'rubocop', '~> 1.0'
end
