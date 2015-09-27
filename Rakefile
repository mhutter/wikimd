require 'bundler/gem_tasks'

# RSpec task
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

# Cucumber task
begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
  end
rescue LoadError
end
