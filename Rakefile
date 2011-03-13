require 'rubygems'
require 'rake'
require 'metric_fu'

require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'mixpanel_client'
    gem.summary = 'Ruby Mixpanel API Client Library'
    gem.description = 'Simple ruby client interface to the Mixpanel API.'
    gem.email = 'keolo@dreampointmedia.com'
    gem.homepage = 'http://github.com/keolo/mixpanel_client'
    gem.authors = ['Keolo Keagy']
    gem.add_development_dependency 'rspec', '>= 2.4.0'
    gem.add_development_dependency 'webmock', '>= 1.6.2'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color']
end

namespace :spec do
  desc 'Run all tests that depend on external dependencies'
  RSpec::Core::RakeTask.new(:externals) do |t|
    t.pattern = 'spec/**/*_externalspec.rb'
    t.rspec_opts = ['--color']
  end
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort 'Cucumber is not available. In order to run features, you must: sudo gem install cucumber'
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mixpanel_client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
