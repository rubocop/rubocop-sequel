module RuboCop
  module Cop
    module Sequel
      # ConcurrentIndex looks for non-concurrent index creation.
      class ConcurrentIndex < Cop
        MSG = 'Prefer creating new index concurrently'.freeze

        def_node_matcher :add_index, <<-MATCHER
          (send _ :add_index $...)
        MATCHER

        def on_send(node)
          add_index(node) do |args|
            if offensive?(args)
              add_offense(node, location: :selector, message: MSG)
            end
          end
        end

        private

        def offensive?(args)
          !args.last.hash_type? || args.last.each_descendant.none? do |n|
            next unless n.sym_type?
            n.children.any? { |s| s == :concurrently }
          end
        end
      end
    end
  end
end
