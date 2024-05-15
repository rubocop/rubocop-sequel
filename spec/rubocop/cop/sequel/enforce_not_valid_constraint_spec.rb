# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sequel::EnforceNotValidConstraint do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) { { 'Enabled' => true } }
  let(:config) { RuboCop::Config.new('Sequel/EnforceNotValidConstraint' => cop_config) }

  context 'when add_constraint is used' do
    it 'registers an offense when used without `not_valid: true` argument' do
      offenses = inspect_source(<<~RUBY)
        alter_table :foo do
          add_constraint :not_valid, Sequel.lit("jsonb_typeof(column) = 'object'")
          add_constraint({name: "not_valid"}, Sequel.lit("jsonb_typeof(column) = 'object'"))
        end
      RUBY

      expect(offenses.size).to eq(2)
    end

    it 'registers an offense when used with `not_valid: false` argument' do
      offenses = inspect_source(<<~RUBY)
        alter_table :foo do
          add_constraint({name: "valid", not_valid: false}, Sequel.lit("jsonb_typeof(column) = 'object'"))
        end
      RUBY

      expect(offenses.size).to eq(1)
    end

    it 'does not register an offense when using `not_valid: true` argument' do
      offenses = inspect_source(<<~RUBY)
        alter_table :foo do
          add_constraint({name: "name", not_valid: true }, Sequel.lit("jsonb_typeof(column) = 'object'"))
        end
      RUBY

      expect(offenses.size).to eq(0)
    end

    context 'when wrap with additional block' do
      it 'registers an offense when used with `not_valid: false` argument' do
        offenses = inspect_source(<<~RUBY)
          alter_table :foo do
            begin
              add_constraint({name: "valid", not_valid: false}, Sequel.lit("jsonb_typeof(column) = 'object'"))
            end
          end
        RUBY

        expect(offenses.size).to eq(1)
      end
    end

    context 'when hash-rockets is used to define argument' do
      it "does not register an offense when using `'not_valid' => true` argument" do
        offenses = inspect_source(<<~RUBY)
          alter_table :foo do
            add_constraint({name: "name", "not_valid" => true }, Sequel.lit("jsonb_typeof(column) = 'object'"))
          end
        RUBY

        expect(offenses.size).to eq(0)
      end
    end
  end

  context 'when add_foreign_key is used' do
    it 'registers an offense when used without `not_valid: true` argument' do
      offenses = inspect_source(<<~RUBY)
        alter_table :foo do
          add_foreign_key(:not_valid, :table)
          add_foreign_key(:not_valid, :table, name: "not_valid")
        end
      RUBY

      expect(offenses.size).to eq(2)
    end

    it 'registers an offense when used with `not_valid: false` argument' do
      offenses = inspect_source(<<~RUBY)
        alter_table :foo do
          add_foreign_key(:valid, :table, name: "not_valid", not_valid: false)
        end
      RUBY

      expect(offenses.size).to eq(1)
    end

    it 'does not register an offense when using `not_valid: true` argument' do
      offenses = inspect_source(<<~RUBY)
        alter_table :foo do
          add_foreign_key(:not_valid, :table, name: "not_valid", not_valid: true)
        end
      RUBY

      expect(offenses.size).to eq(0)
    end
  end

  context 'with ExcludeTables setting' do
    let(:cop_config) do
      {
        'Enabled' => true,
        'ExcludeTables' => ['excluded_table']
      }
    end

    it 'does not register an offense when using `not_valid: true` argument inside excluded table migration' do
      offenses = inspect_source(<<~RUBY)
        alter_table :excluded_table do
          add_foreign_key(:not_valid, :table)
          add_foreign_key(:not_valid, :table, name: "not_valid")
        end
      RUBY

      expect(offenses.size).to eq(0)
    end

    it 'register an offense when using `not_valid: true` argument for not excluded table' do
      offenses = inspect_source(<<~RUBY)
        alter_table :not_excluded_table do
          add_foreign_key(:not_valid, :table)
          add_foreign_key(:not_valid, :table, name: "not_valid")
        end
      RUBY

      expect(offenses.size).to eq(2)
    end
  end

  context 'with IncludeTables setting' do
    let(:cop_config) do
      {
        'Enabled' => true,
        'IncludeTables' => ['included_table']
      }
    end

    it 'does not register an offense when using `not_valid: true` argument inside excluded table migration' do
      offenses = inspect_source(<<~RUBY)
        alter_table :included_table do
          add_foreign_key(:not_valid, :table)
          add_foreign_key(:not_valid, :table, name: "not_valid")
        end
      RUBY

      expect(offenses.size).to eq(2)
    end

    it 'register an offense when using `not_valid: true` argument for not excluded table' do
      offenses = inspect_source(<<~RUBY)
        alter_table :not_included_table do
          add_foreign_key(:not_valid, :table)
          add_foreign_key(:not_valid, :table, name: "not_valid")
        end
      RUBY

      expect(offenses.size).to eq(0)
    end
  end
end
