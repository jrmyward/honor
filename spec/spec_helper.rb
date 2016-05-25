require 'rails/all'
require 'rubygems'
require 'honor'
require 'ammeter/init'
require 'timecop'
require 'database_cleaner'

# set adapter to use, default is sqlite3
# to use an alternative adapter run => rake spec DB='postgresql'
db_name = ENV['DB'] || 'sqlite3'
database_yml = File.expand_path('../config/database.yml', __FILE__)

if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)

  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations[db_name]

  begin
    ActiveRecord::Base.establish_connection(db_name.to_sym)
    ActiveRecord::Base.connection
  rescue
    case db_name
    when /mysql/
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'],  {:charset => 'utf8', :collation => 'utf8_unicode_ci'})
    when 'postgresql'
      ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => 'utf8'))
    end

    ActiveRecord::Base.establish_connection(config)
  end

  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
  ActiveRecord::Base.default_timezone = :utc

  #ActiveRecord::Base.logger.silence do
    ActiveRecord::Migration.verbose = false

    load(File.expand_path('../config/schema.rb', __FILE__))
    load(File.expand_path('../config/models.rb', __FILE__))
  #end

else
  raise "Please create #{database_yml} first to configure your database. Take a look at: spec/config/database.yml.sample"
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
