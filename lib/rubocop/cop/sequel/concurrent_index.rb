module RuboCop
  module Cop
    module Sequel
      # ConcurrentIndex looks for non-concurrent index creation.
      class ConcurrentIndex < Cop
        MSG = 'Prefer creating new index concurrently'.freeze

        def_node_matcher :add_index, <<-END
          (send _ :add_index $...)
        END

        def on_send(node)
          add_index(node) do |args|
            add_offense(node, location: :selector, message: MSG) if offensive?(args)
          end
        end

        private

        def offensive?(args)
          !args.last.hash_type? || !args.last.each_descendant.any? do |n|
            next unless n.sym_type?
            n.children.any? { |s| s == :concurrently }
          end
        end
      end
    end
  end
end
