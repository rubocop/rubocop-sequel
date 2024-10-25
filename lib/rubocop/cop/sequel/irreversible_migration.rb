# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # IrreversibleMigration looks for methods inside a `change` block that cannot be reversed.
      class IrreversibleMigration < Base
        include Helpers::Migration

        # https://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html#label-A+Basic+Migration
        VALID_CHANGE_METHODS = %i[
          create_table
          create_join_table
          create_view
          add_column
          add_index
          rename_column
          rename_table
          alter_table
          add_column
          add_constraint
          add_foreign_key
          add_primary_key
          add_index
          add_full_text_index
          add_spatial_index
          rename_column
          set_column_allow_null
        ].freeze

        MSG = 'Avoid using "%<name>s" inside a "change" block. Use "up" & "down" blocks instead.'
        PRIMARY_KEY_MSG = 'Avoid using "add_primary_key" with an array argument inside a "change" block.'

        def on_block(node)
          return unless node.method_name == :change
          return unless within_sequel_migration?(node)

          body = node.body
          return unless body

          body.each_node(:send) { |child_node| validate_node(child_node) }
        end

        private

        def validate_node(node)
          name = node.method_name

          add_offense(node.loc.selector, message: format(MSG, name: name)) unless VALID_CHANGE_METHODS.include?(name)

          return unless name == :add_primary_key

          return unless node.arguments.any?(&:array_type?)

          add_offense(node.loc.selector, message: PRIMARY_KEY_MSG)
        end
      end
    end
  end
end
