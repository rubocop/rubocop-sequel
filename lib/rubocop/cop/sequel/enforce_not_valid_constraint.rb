# frozen_string_literal: true

module RuboCop
  module Cop
    module Sequel
      # Ensures that new constraints are created with the `not_valid: true` option.
      #
      # This cop checks database migration files for `add_foreign_key` and
      # `add_constraint` operations to ensure that new constraints are created
      # with the `not_valid: true` option, which is necessary for deferred validation.
      #
      # This cop can be configured to exclude or include specific tables through
      # the `ExcludeTables` and `IncludeTables` options.
      #
      # @example
      #   # bad
      #   add_foreign_key :users, :orders, column: :user_id
      #
      #   # good
      #   add_foreign_key :users, :orders, column: :user_id, not_valid: true
      #
      #   # bad
      #   alter_table :users do
      #     add_constraint(:user_email_check) { "email IS NOT NULL" }
      #   end
      #
      #   # good
      #   alter_table :users do
      #     add_constraint(:user_email_check, not_valid: true) { "email IS NOT NULL" }
      #   end
      #
      # @example Configuration
      #   Sequel/EnforceNotValidConstraint:
      #     Enabled: true
      #     Include:
      #       - "db/migrations"
      #     ExcludeTables:
      #       - users
      #     IncludeTables:
      #       - comments
      class EnforceNotValidConstraint < Base
        MSG = "Add the 'not_valid: true' option when creating new constraints to ensure " \
              'they are not validated immediately.'

        # Matcher for alter_table blocks
        def_node_matcher :alter_table_block?, <<-MATCHER
          (block
            (send _ :alter_table ({str sym} $_))
            _
            (begin
              $...
            )
          )
        MATCHER

        # Matcher for constraint operations like add_foreign_key and add_constraint
        def_node_matcher :constraint_operation?, <<-MATCHER
          (send _ {:add_foreign_key :add_constraint} $...)
        MATCHER

        # Check constraint operations inside the alter_table block
        #
        # @param node [RuboCop::AST::Node] the AST node being checked
        def on_block(node)
          alter_table_block?(node) do |table_name, block_nodes|
            next if skip_table?(table_name)

            block_nodes.each { |block_node| validate_node(block_node) }
          end
        end

        private

        # Validate constraint operations
        #
        # @param node [RuboCop::AST::Node] the AST node being checked
        def validate_node(node)
          constraint_operation?(node) do |args|
            next if not_valid_option_present?(args)

            add_offense(node, message: MSG)
          end
        end

        # Check if the not_valid: true option is present
        #
        # @param args [Array<RuboCop::AST::Node>] the operation arguments
        # @return [Boolean] whether the not_valid: true option is present
        def not_valid_option_present?(args)
          args.any? do |arg|
            arg.hash_type? && arg.pairs.any? do |pair|
              key = pair.key
              value = pair.value
              key.sym_type? && key.children.first == :not_valid && value.true_type?
            end
          end
        end

        # Skip the table if it is excluded or not included
        #
        # @param table_name [String] the name of the table
        # @return [Boolean] whether the table should be skipped
        def skip_table?(table_name)
          return true if excluded_table?(table_name.to_s)

          !included_table?(table_name.to_s)
        end

        def excluded_table?(table_name)
          return false unless cop_config.key?('ExcludeTables')

          cop_config['ExcludeTables'].include?(table_name)
        end

        def included_table?(table_name)
          return true unless cop_config.key?('IncludeTables')

          cop_config['IncludeTables'].include?(table_name)
        end
      end
    end
  end
end
