# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Sequel::PartialConstraint do
  subject(:cop) { described_class.new }

  it 'registers an offense when using where for constraint' do
    inspect_source <<-RUBY
      add_unique_constraint %i[col_1 col_2], where: "state != 'deleted'"
    RUBY

    expect(cop.offenses.size).to eq(1)
    offense = cop.offenses.first
    expect(offense.message).to eq("Constraint can't be partial, use where argument with index")
  end
end
