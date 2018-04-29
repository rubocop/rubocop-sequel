# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Sequel::JSONColumn do
  subject(:cop) { described_class.new }

  context 'with add_column' do
    it 'registers an offense when using json type' do
      inspect_source('add_column(:products, :type, :json)')
      expect(cop.offenses.size).to eq(1)
    end

    it 'registers an offense when using hstore type' do
      inspect_source('add_column(:products, :type, :hstore)')
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using jsonb' do
      inspect_source('add_column(:products, :type, :jsonb)')
      expect(cop.offenses).to be_empty
    end
  end

  context 'with create_table' do
    it 'registers an offense when using json as a method' do
      inspect_source('create_table(:products) { json :type, default: {} }')
      expect(cop.offenses.size).to eq(1)
    end

    it 'registers an offense when using the column method with hstore' do
      inspect_source('create_table(:products) { column :type, :hstore }')
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using jsonb as column type`' do
      inspect_source('create_table(:products) { column :type, :jsonb }')
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when using jsonb' do
      inspect_source('create_table(:products) { jsonb :type }')
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when using a simple type' do
      inspect_source('create_table(:products) { integer :type, default: 0 }')
      expect(cop.offenses).to be_empty
    end
  end
end
