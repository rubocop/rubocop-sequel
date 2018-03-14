# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Sequel::ConcurrentIndex do
  subject(:cop) { described_class.new }

  context 'without the concurrent option' do
    it 'registers an offense without options' do
      inspect_source(<<~SOURCE)
        add_index(:products, :name)
        drop_index(:products, :name)
      SOURCE
      expect(cop.offenses.size).to eq(2)
    end

    it 'registers an offense with other options' do
      inspect_source(<<~SOURCE)
        add_index(:products, :name, unique: true)
        drop_index(:products, :name, unique: true)
      SOURCE
      expect(cop.offenses.size).to eq(2)
    end

    it 'registers an offense with composite index' do
      inspect_source(<<~SOURCE)
        add_index(:products, [:name, :price], unique: true)
        drop_index(:products, [:name, :price])
      SOURCE
      expect(cop.offenses.size).to eq(2)
    end
  end

  it 'does not register an offense when using concurrent option' do
    inspect_source(<<~SOURCE)
      add_index(:products, :name, unique: true, concurrently: true)
      drop_index(:products, :name, concurrently: true)
    SOURCE
    expect(cop.offenses).to be_empty
  end
end
