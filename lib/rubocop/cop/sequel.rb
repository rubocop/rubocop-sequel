# frozen_string_literal: true

require_relative 'sequel/helpers/migration'

module RuboCop
  module Cop
    # Cops for the `Sequel` department. The department's cops are
    # registered for lazy loading and their files are loaded on demand.
    module Sequel
      extend LazyLoader

      register_cop :ConcurrentIndex, "#{__dir__}/sequel/concurrent_index"
      register_cop :IrreversibleMigration, "#{__dir__}/sequel/irreversible_migration"
      register_cop :JSONColumn, "#{__dir__}/sequel/json_column"
      register_cop :MigrationName, "#{__dir__}/sequel/migration_name"
      register_cop :SaveChanges, "#{__dir__}/sequel/save_changes"
      register_cop :PartialConstraint, "#{__dir__}/sequel/partial_constraint"
    end
  end
end
