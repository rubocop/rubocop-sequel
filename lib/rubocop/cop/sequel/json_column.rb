# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # JSONColumn looks for non-JSONB columns.
      class JSONColumn < Base
        MSG = 'Use JSONB rather than JSON or hstore'

        def_node_matcher :json_or_hstore?, <<-MATCHER
          (send _ :add_column ... (sym {:json :hstore}))
        MATCHER

        def_node_matcher :column_type?, <<-MATCHER
          (send _ {:json :hstore} ...)
        MATCHER

        def_node_matcher :column_method?, <<-MATCHER
          (send _ :column ... (sym {:json :hstore}))
        MATCHER

        def on_send(node)
          return unless json_or_hstore?(node)

          add_offense(node.loc.selector, message: MSG)
        end

        def on_block(node)
          return unless node.send_node.method_name == :create_table

          node.each_node(:send) do |method|
            next unless column_method?(method) || column_type?(method)

            add_offense(method.loc.selector, message: MSG)
          end
        end
      end
    end
  end
end
