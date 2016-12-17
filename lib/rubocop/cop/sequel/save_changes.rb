module RuboCop
  module Cop
    module Sequel
      # SaveChanges promotes the use of save_changes.
      class SaveChanges < Cop
        MSG = 'Use `Sequel::Model#save_changes` instead of `Sequel::Model#save`.'.freeze

        def_node_matcher :model_save, <<-END
          (send _ :save)
        END

        def on_send(node)
          add_offense(node, :selector, MSG) if model_save(node)
        end

        def autocorrect(node)
          ->(corrector) { corrector.replace(node.loc.selector, 'save_changes') }
        end
      end
    end
  end
end
