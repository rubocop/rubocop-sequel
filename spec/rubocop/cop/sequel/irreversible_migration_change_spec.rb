# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sequel::IrreversibleMigrationChange do
  subject(:cop) { described_class.new }

  context 'when inside a change block' do
    let(:offensive_source) do
      <<~SOURCE
        change do
          drop_column(:products, :name)
          drop_index(:products, :price)
        end
      SOURCE
    end

    let(:valid_source) do
      <<~SOURCE
        change do
          add_column(:products, :name)
          add_index(:products, :price)
        end
      SOURCE
    end

    it 'registers an offense when there is an invalid method' do
      offenses = inspect_source(offensive_source)
      expect(offenses.size).to eq(2)
    end

    it 'does not register an offense with valid methods' do
      offenses = inspect_source(valid_source)
      expect(offenses.size).to be_empty
    end
  end

  context 'when inside an up block' do
    let(:source) do
      <<~SOURCE
        change do
          add_column(:products, :name)
          drop_index(:products, :price)
        end
      SOURCE
    end

    it 'does not register an offense with any methods' do
      offenses = inspect_source(source)
      expect(offenses.size).to be_empty
    end
  end
end
