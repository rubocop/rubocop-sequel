module RuboCop
  module Cop
    module Sequel
      # ColumnDefault looks for column creation with a default value.
      class ColumnDefault < Cop
        MSG = "Don't create new column with default values".freeze

        def_node_matcher :add_column_default, <<-MATCHER
          (send _ :add_column ... (hash (pair (sym :default) _)))
        MATCHER

        def on_send(node)
          return unless add_column_default(node)
          add_offense(node, location: :selector, message: MSG)
        end
      end
    end
  end
end
