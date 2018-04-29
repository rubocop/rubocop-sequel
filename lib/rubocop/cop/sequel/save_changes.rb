# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # SaveChanges promotes the use of save_changes.
      class SaveChanges < Cop
        MSG = 'Use `Sequel::Model#save_changes` instead of '\
          '`Sequel::Model#save`.'

        def_node_matcher :model_save?, <<-MATCHER
          (send _ :save)
        MATCHER

        def on_send(node)
          return unless model_save?(node)
          add_offense(node, location: :selector, message: MSG)
        end

        def autocorrect(node)
          ->(corrector) { corrector.replace(node.loc.selector, 'save_changes') }
        end
      end
    end
  end
end
