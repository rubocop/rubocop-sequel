require 'spec_helper'

describe RuboCop::Cop::Sequel::ConcurrentIndex do
  subject(:cop) { described_class.new }

  context 'without the concurrent option' do
    it 'registers an offense without options' do
      inspect_source('add_index(:products, :name)')
      expect(cop.offenses.size).to eq(1)
    end

    it 'registers an offense with other options' do
      inspect_source('add_index(:products, :name, unique: true)')
      expect(cop.offenses.size).to eq(1)
    end

    it 'registers an offense with composite index' do
      inspect_source('add_index(:products, :name, unique: true)')
      expect(cop.offenses.size).to eq(1)
    end
  end

  it 'does not register an offense when using concurrent option' do
    inspect_source('add_index(:products, :name, unique: true, concurrently: true)')
    expect(cop.offenses).to be_empty
  end
end
