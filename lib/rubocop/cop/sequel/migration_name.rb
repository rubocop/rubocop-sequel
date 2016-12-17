module RuboCop
  module Cop
    module Sequel
      # MigrationName looks for migration files named with a default name.
      class MigrationName < Cop
        MSG = 'Migration files should not use default name.'.freeze

        def investigate(processed_source)
          file_path = processed_source.buffer.name
          return if config.file_to_include?(file_path)

          return unless filename_bad?(file_path)

          add_offense(nil, source_range(processed_source.buffer, 1, 0), nil)
        end

        private

        def filename_bad?(path)
          # TODO: Use configuration
          basename = File.basename(path)
          basename =~ /new_migration/
        end
      end
    end
  end
end
