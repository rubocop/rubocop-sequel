# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Sequel::PartialConstraint do
  subject(:cop) { described_class.new }

  it 'registers an offense when using where for constraint' do
    inspect_source <<-RUBY
      add_unique_constraint %i[col_1 col_2], where: "state != 'deleted'"
    RUBY

    expect(cop.offenses.size).to eq(1)
  end
end
