require 'rubygems'
require 'rake'
require 'metric_fu'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'mixpanel_client'
    gem.summary = 'Ruby Mixpanel API Client Library'
    gem.description = 'Simple ruby client interface to the Mixpanel API.'
    gem.email = 'keolo@dreampointmedia.com'
    gem.homepage = 'http://github.com/keolo/mixpanel_client'
    gem.authors = ['Keolo Keagy']
    gem.add_development_dependency 'rspec', '>= 1.2.9'
    gem.add_development_dependency 'cucumber', '>= 0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
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
