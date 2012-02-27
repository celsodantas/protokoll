require 'rails/generators'

module Protokoll
  module Generators
    class MigrationGenerator < ::Rails::Generators::Base
      
       include Rails::Generators::Migration
      
      desc "Generate protokoll migration" 
      def create_migration_file
        migration_name = "create_custom_auto_increments.rb"
        migration_template migration_name, File.join('db', 'migrate', migration_name)
      end
      
      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end