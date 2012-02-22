require 'rails/generators/migration'

module Protokoll
  module Generators
    class MigrateGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      def self.source_root
        #@migration_file = File.expand_patch(File)
      end

    end
  end
end
