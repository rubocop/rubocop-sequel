# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # PartialConstraint looks for missed usage of partial indexes.
      class PartialConstraint < Base
        MSG = "Constraint can't be partial, use where argument with index"

        def_node_matcher :add_partial_constraint?, <<-MATCHER
          (send _ :add_unique_constraint ... (hash (pair (sym :where) _)))
        MATCHER

        def on_send(node)
          return unless add_partial_constraint?(node)

          add_offense(node.loc.selector, message: MSG)
        end
      end
    end
  end
end
