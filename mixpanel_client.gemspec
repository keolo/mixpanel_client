# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'mixpanel/version'

Gem::Specification.new do |s|
  s.license     = 'MIT'
  s.name        = 'mixpanel_client'
  s.version     = Mixpanel::Client::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Keolo Keagy']
  s.email       = ['keolo@kea.gy']
  s.homepage    = 'http://github.com/keolo/mixpanel_client' 
  s.summary     = %q{Ruby Mixpanel API Client Library}
  s.description = %q{Simple ruby client interface to the Mixpanel API.}

  s.rubyforge_project = 'mixpanel_client'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_runtime_dependency('typhoeus')
  s.add_development_dependency('bundler', '>=1.5.3')
  s.add_development_dependency('rake',    '>=10.1.1')
  s.add_development_dependency('rdoc',    '>=4.1.1')
  s.add_development_dependency('rspec',   '>=2.5.0')
  s.add_development_dependency('webmock', '>=1.17.4')
  s.add_development_dependency('pry',     '>=0.9.12.6')
  s.add_development_dependency('pry-byebug', '>=1.3.2') if RUBY_VERSION >= '2.0'
  s.add_development_dependency('pry-stack_explorer', '>=0.4.9')
  s.add_development_dependency('rubocop', '>=0.19.0')
end
