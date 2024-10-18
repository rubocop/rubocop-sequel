# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # IrreversibleMigration looks for methods inside a `change` block that cannot be reversed.
      class IrreversibleMigration < Base
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

        MSG = 'Avoid using this method inside a `change` block. Use a `down` block instead.'
        PRIMARY_KEY_MSG = 'Avoid using this method with an array argument inside a `change` block.'

        def on_block(node)
          return unless node.method_name == :change

          body = node.body
          return unless body

          body.each_node(:send) { |child_node| validate_node(child_node) }
        end

        private

        def validate_node(node)
          add_offense(node.loc.selector, message: MSG) unless VALID_CHANGE_METHODS.include?(node.method_name)

          return unless node.method_name == :add_primary_key

          return unless node.arguments.any?(&:array_type?)

          add_offense(node.loc.selector, message: PRIMARY_KEY_MSG)
        end
      end
    end
  end
end
