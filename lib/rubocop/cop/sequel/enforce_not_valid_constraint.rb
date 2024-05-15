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
      # By using the not_valid: true option, the constraint is created but not enforced
      # on existing data. This allows the database to continue operating normally without
      # the overhead of immediate validation. You can then validate the existing data
      # in a controlled manner using a separate process or during off-peak hours,
      # minimizing the impact on your application’s performance. This approach ensures
      # that the new constraint is applied to new data immediately while providing
      # flexibility in handling existing data, promoting better performance and
      # stability during schema changes. Also it is a good
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
            $...
          )
        MATCHER

        # Matcher for constraint operations like add_foreign_key and add_constraint
        def_node_search :constraint_operations, <<~MATCHER
          (send _ {:add_foreign_key :add_constraint} ...)
        MATCHER

        # Matcher for check if the not_valid: true argument is present
        def_node_search :not_valid_constraint?, <<~MATCHER
          (pair (_ {:not_valid "not_valid"}) true)
        MATCHER

        # Check constraint operations inside the alter_table block
        #
        # @param node [RuboCop::AST::Node] the AST node being checked
        def on_block(node)
          alter_table_block?(node) do |table_name, _block_nodes|
            next if exclude_table?(table_name)

            constraint_operations(node).each do |block_node|
              validate_node(block_node)
            end
          end
        end

        private

        # Validate constraint operations
        #
        # @param node [RuboCop::AST::Node] the AST node being checked
        def validate_node(node)
          add_offense(node, message: MSG) unless not_valid_constraint?(node)
        end

        # Skip the table if it is excluded or not included
        #
        # @param table_name [String,Symbol] the name of the table
        # @return [Boolean] whether the table should be skipped
        def exclude_table?(table_name)
          return true if cop_config['ExcludeTables']&.include?(table_name.to_s)
          return false unless cop_config.key?('IncludeTables')

          !cop_config['IncludeTables'].include?(table_name.to_s)
        end
      end
    end
  end
end
