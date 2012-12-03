# via http://www.sinatrarb.com/faq#ar-migrations
namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end