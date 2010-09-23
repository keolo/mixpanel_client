$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mixpanel_client'
require 'spec'
require 'spec/autorun'
require 'webmock/rspec'

Spec::Runner.configure do |config|
  config.include WebMock
end
