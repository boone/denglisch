# via http://www.sinatrarb.com/faq#ar-migrations
namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
  
  desc "Create the database"
  task :create do
    require 'yaml'
    require 'active_record'
    DB_CONFIG ||= YAML.load_file("./config/database.yml")[ENV['RACK_ENV']]
    ActiveRecord::Base.establish_connection(:adapter => DB_CONFIG['adapter'], :database => nil,
                                            :username => DB_CONFIG['username'], :password => DB_CONFIG['password'],
                                            :host => DB_CONFIG['host'], :encoding => DB_CONFIG['encoding'],
                                            :reconnect => DB_CONFIG['reconnect'], :pool => DB_CONFIG['pool'])
    ActiveRecord::Base.connection.create_database(DB_CONFIG['database'],
                                                  :charset => DB_CONFIG['charset'], :collation => DB_CONFIG['collation'])
    ActiveRecord::Base.establish_connection(:adapter => DB_CONFIG['adapter'], :database => DB_CONFIG['database'],
                                            :username => DB_CONFIG['username'], :password => DB_CONFIG['password'],
                                            :host => DB_CONFIG['host'], :encoding => DB_CONFIG['encoding'],
                                            :reconnect => DB_CONFIG['reconnect'], :pool => DB_CONFIG['pool'])
  end
  
  desc "Drop the database"
  task(:drop => :environment) do
    begin
      ActiveRecord::Base.connection.drop_database DB_CONFIG['database']
    rescue Exception => e
      if e.to_s =~ /Unknown database/
        puts e
      else
        raise e
      end
    end
  end
end
