# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'cop lazy loading', type: :feature do
  let(:cop_root) { File.expand_path('../lib/rubocop/cop', __dir__) }

  def run_script(source)
    Dir.mktmpdir do |dir|
      script = File.join(dir, 'script.rb')
      File.write(script, source)
      output = `#{RbConfig.ruby} -I #{File.expand_path('../lib', __dir__)} #{script} 2>&1`
      raise "script failed:\n#{output}" unless $CHILD_STATUS.success?

      output
    end
  end

  it 'registers every cop file in `lib/rubocop/cop/sequel` exactly once' do
    files = Dir[File.join(cop_root, 'sequel', '*.rb')].sort
    registered = RuboCop::Cop::Registry.global.cops_for_department(:Sequel).map do |cop|
      Object.const_source_location(cop.name).first
    end

    expect(registered.sort).to eq(files)
  end

  it 'registers all cops without loading their files' do # rubocop:disable RSpec/ExampleLength
    output = run_script(<<~RUBY)
      require 'rubocop-sequel'

      registry = RuboCop::Cop::Registry.global
      loaded = $LOADED_FEATURES.grep(%r{/rubocop/cop/sequel/(?!helpers/)})

      puts "registered=\#{registry.names.grep(%r{\\ASequel/}).size}"
      puts "loaded_cop_files=\#{loaded.size}"
    RUBY

    expect(output).to include('registered=6', 'loaded_cop_files=0')
  end

  it 'does not register a cop twice when its file is required directly' do # rubocop:disable RSpec/ExampleLength
    output = run_script(<<~RUBY)
      require 'rubocop-sequel'

      before = RuboCop::Cop::Registry.global.length
      require 'rubocop/cop/sequel/json_column'
      after = RuboCop::Cop::Registry.global.length

      puts "stable=\#{before == after}"
      puts "class=\#{RuboCop::Cop::Registry.global.find_by_cop_name('Sequel/JSONColumn')}"
    RUBY

    expect(output).to include('stable=true', 'class=RuboCop::Cop::Sequel::JSONColumn')
  end
end
