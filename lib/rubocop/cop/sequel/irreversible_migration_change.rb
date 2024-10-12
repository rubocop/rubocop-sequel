# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # IrreversibleMigrationChange looks for methods inside a `change` block that cannot be reversed.
      class IrreversibleMigrationChange < Base
        # https://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html#label-A+Basic+Migration
        VALID_CHANGE_METHODS = %w[
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

        MSG = 'This method should not be used in a `change` block. Use a `down` block instead.'
        PRIMARY_KEY_MESSAGE = 'Cannot use this method with an array parameter inside a `change` block. Use a `down` block instead.'

        def on_block(node)
          return unless node.method_name == :change

          body = node.body
          return unless body

          body.each_node(:send) do |node|
            add_offense(node.loc.selector, message: MSG) unless VALID_CHANGE_METHODS.include?(node.method_name)

            return unless node.method_name == :add_primary_key

            add_offense(node.loc.selector, message: PRIMARY_KEY_MESSAGE) if node.argument_list.any? { |arg| arg.is_a? Array }
          end
        end
      end
    end
  end
end
