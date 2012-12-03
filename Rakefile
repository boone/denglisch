require 'rspec'
require 'rspec/core/rake_task'

task :default => :spec

desc "Run all specs in spec directory, except plugins"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = %w[-w]
  t.rspec_opts = %w[--color]
end

#desc "Set up environment"
task :environment do
  require File.dirname(__FILE__) + '/denglisch'
end

# include rake tasks in lib/tasks
Dir[File.dirname(__FILE__) + '/lib/tasks/**/*.rake'].sort.each { |ext| load ext }
