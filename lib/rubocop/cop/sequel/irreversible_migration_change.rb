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
          add_primary_key(with a symbol, not an array)
          add_index
          add_full_text_index
          add_spatial_index
          rename_column
          set_column_allow_null
        ].freeze

        MSG = 'This method should not be used in a `change` block. Use a `down` block instead.'

        def_node_matcher :change_block_method?, <<~PATTERN
          blah blah
        PATTERN

        def on_send(node)
          change_block_method?(node) do |args|
            add_offense(node.loc.selector, message: MSG) if offensive?(args)
          end
        end

        private

        def offensive?(args)
          !VALID_CHANGE_METHODS.include?(args)
        end
      end
    end
  end
end
