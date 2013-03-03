require 'rails/generators/migration'

module Honor
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Generates migration for Points and Scorecard"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template 'create_points.rb', 'db/migrate/create_honor_points.rb'
        migration_template 'create_scorecards.rb', 'db/migrate/create_honor_scorecards.rb'
      end
    end
  end
end