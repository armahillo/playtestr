require 'rspec/core/rake_task'
require 'rake/clean'
require_relative './lib/playtestr'


Dir.glob('./lib/tasks/*.rake') do |rake_task|
  import rake_task
end

CLOBBER << FileList['./export/*.pdf', './export/*.html', './import/*.yml']

RSpec::Core::RakeTask.new(:spec) do |t|
end

task default: :spec