# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sequel::IrreversibleMigration do
  subject(:cop) { described_class.new }

  context 'when inside a change block' do
    let(:invalid_source) do
      <<~SOURCE
        Sequel.migration do
          change do
            alter_table(:stores) do
              drop_column(:products, :name)
              drop_index(:products, :price)
            end
          end
        end
      SOURCE
    end

    let(:valid_source) do
      <<~SOURCE
        Sequel.migration do
          change do
            alter_table(:stores) do
              add_primary_key(:id)
              add_column(:products, :name)
              add_index(:products, :price)
            end
          end
        end
      SOURCE
    end

    it 'registers an offense when there is an invalid method' do
      offenses = inspect_source(invalid_source)
      expect(offenses.size).to eq(2)
    end

    it 'does not register an offense with valid methods' do
      offenses = inspect_source(valid_source)
      expect(offenses).to be_empty
    end

    describe 'and an array is passed into `add_primary_key`' do
      let(:source) do
        <<~SOURCE
          Sequel.migration do
            change do
              alter_table(:stores) do
                add_primary_key([:owner_id, :name])
              end
            end
          end
        SOURCE
      end

      it 'registers an offense' do
        offenses = inspect_source(source)
        expect(offenses.size).to eq(1)
      end
    end
  end

  context 'when inside an up block' do
    let(:source) do
      <<~SOURCE
        Sequel.migration do
          up do
            alter_table(:stores) do
              add_primary_key([:owner_id, :name])
              add_column(:products, :name)
              drop_index(:products, :price)
            end
          end
        end
      SOURCE
    end

    it 'does not register an offense with any methods' do
      offenses = inspect_source(source)
      expect(offenses).to be_empty
    end
  end

  context 'when a change block is used outside of a Sequel migration' do
    let(:source) do
      <<~SOURCE
        it { expect { subject }.to change { document_count(user_id) }.by(-1) }
      SOURCE
    end

    it 'does not register an offense with any methods' do
      offenses = inspect_source(source)
      expect(offenses).to be_empty
    end
  end
end
