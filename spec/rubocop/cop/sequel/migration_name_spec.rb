require 'spec_helper'

describe RuboCop::Cop::Sequel::MigrationName, :config do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new(
      { 'AllCops' => { 'Include' => [] },
        'Sequel/MigrationName' => cop_config },
      '/some/.rubocop.yml'
    )
  end

  context 'default configuration' do
    let(:cop_config) { {} }

    it 'registers an offense when using the default name' do
      inspect_source(cop, '', 'new_migration.rb')
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using a specific name' do
      inspect_source(cop, '', 'add_index.rb')
      expect(cop.offenses).to be_empty
    end
  end

  context 'with custom configuration' do
    let(:cop_config) { { 'DefaultName' => 'add_migration' } }

    it 'registers an offense when using the default name' do
      inspect_source(cop, '', 'add_migration.rb')
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using a specific name' do
      inspect_source(cop, '', 'add_index.rb')
      expect(cop.offenses).to be_empty
    end
  end
end
