$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mixpanel_client'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
end
