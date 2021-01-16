# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Sequel::ColumnDefault do
  subject(:cop) { described_class.new }

  it 'registers an offense when setting a default' do
    offenses = inspect_source('add_column(:products, :type, :text, default: "cop")')
    expect(offenses.size).to eq(1)
  end

  it 'does not register an offense when not setting a default' do
    offenses = inspect_source('add_column(:products, :type, :text)')
    expect(offenses).to be_empty
  end
end
