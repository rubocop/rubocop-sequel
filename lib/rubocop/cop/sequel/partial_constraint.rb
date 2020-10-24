# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      class PartialConstraint < Cop
        MSG = "Constraint can't be partial, use where argument with index"

        def_node_matcher :add_partial_constraint?, <<-MATCHER
          (send _ :add_unique_constraint ... (hash (pair (sym :where) _)))
        MATCHER

        def on_send(node)
          return unless add_partial_constraint?(node)

          add_offense(node, location: :selector, message: MSG)
        end
      end
    end
  end
end
