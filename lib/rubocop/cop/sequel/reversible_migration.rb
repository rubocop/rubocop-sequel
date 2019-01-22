# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # ReversibleMigration looks for non-reversible methods used inside `change`
      class ReversibleMigration < Cop
        MSG = '%<action>s is not reversible.'.freeze

        def_node_matcher :drop_index_call, <<-PATTERN
          (send nil? :drop_index ...)
        PATTERN

        def on_send(node)
          return unless within_change_method?(node)

          check_drop_index_call(node)
        end

        private

        def check_drop_index_call(node)
          drop_index_call(node) do
            add_offense(node, message: format(MSG, action: 'drop_index'))
          end
        end

        def within_change_method?(node)
          node.each_ancestor(:def).any? do |ancestor|
            ancestor.method?(:change)
          end
        end
      end
    end
  end
end
