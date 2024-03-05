# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # Constraint created without not_valid option
      class NotValidConstraint < Base
        MSG = 'Prefer creating new constraint with the `not_valid: true` option.'
        RESTRICT_ON_SEND = %i[add_foreign_key add_constraint].freeze

        def_node_matcher :add_constraint_without_not_valid?, <<-MATCHER
          (send _ {:add_foreign_key :add_constraint} $...)
        MATCHER

        def on_send(node)
          add_constraint_without_not_valid?(node) do |args|
            add_offense(node, message: MSG) unless not_valid_option_present?(args)
          end
        end

        def not_valid_option_present?(args)
          args.any? do |arg|
            arg.hash_type? && arg.pairs.any? do |pair|
              key = pair.key
              value = pair.value
              key.sym_type? && key.children.first == :not_valid && value.true_type?
            end
          end
        end
      end
    end
  end
end
