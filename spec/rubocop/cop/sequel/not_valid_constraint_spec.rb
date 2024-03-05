# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Sequel::NotValidConstraint do
  subject(:cop) { described_class.new }

  it 'registers an offense when add_constraint used without valid option' do
    offenses = inspect_source(<<~RUBY)
      add_constraint :not_valid, Sequel.lit("jsonb_typeof(column) = 'object'")
      add_constraint({name: "not_valid"}, Sequel.lit("jsonb_typeof(column) = 'object'"))
    RUBY

    expect(offenses.size).to eq(2)
  end

  it 'registers an offense when add_foregn_key used without valid option' do
    offenses = inspect_source(<<~RUBY)
      add_foreign_key(:not_valid, :table)
      add_foreign_key(:not_valid, :table, name: "not_valid")
    RUBY

    expect(offenses.size).to eq(2)
  end

  it 'does not register an offense when using not valid option' do
    offenses = inspect_source(<<~RUBY)
      add_constraint({name: "name", not_valid: true }, Sequel.lit("jsonb_typeof(column) = 'object'"))
      add_foreign_key(:not_valid, :table, name: "not_valid", not_valid: true)
    RUBY

    expect(offenses.size).to eq(0)
  end
end
