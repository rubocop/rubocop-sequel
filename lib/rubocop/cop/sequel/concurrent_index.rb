# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # ConcurrentIndex looks for non-concurrent index creation.
      class ConcurrentIndex < Cop
        MSG = 'Prefer creating or dropping new index concurrently'

        def_node_matcher :indexes?, <<-MATCHER
          (send _ {:add_index :drop_index} $...)
        MATCHER

        def on_send(node)
          indexes?(node) do |args|
            add_offense(node, location: :selector, message: MSG) if offensive?(args)
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
