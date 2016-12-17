module RuboCop
  module Cop
    module Sequel
      # ColumnDefault looks for column creation with a default value.
      class ColumnDefault < Cop
        MSG = "Don't create new column with default values".freeze

        def_node_matcher :add_column_default, <<-END
          (send _ :add_column ... (hash (pair (sym :default) _)))
        END

        def on_send(node)
          add_offense(node, :selector, MSG) if add_column_default(node)
        end
      end
    end
  end
end
