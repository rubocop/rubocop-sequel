# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Sequel::ReversibleMigration do
  subject(:cop) { described_class.new }

  context 'inside the change block' do
    it 'registers an offense when using drop_index' do
      inspect_source(<<~SOURCE)
        def change
          drop_index(:products, :name, concurrently: true)
        end
      SOURCE
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'outside the change block' do
    it 'does not register an offense when using not supported method' do
      inspect_source(<<~SOURCE)
        def up
          drop_index(:products, :name, concurrently: true)
        end
      SOURCE

      expect(cop.offenses).to be_empty
    end
  end
end
