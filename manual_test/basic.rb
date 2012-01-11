$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'mixpanel_client'
require 'yaml'

config = YAML.load_file(File.dirname(__FILE__) + '/../config/mixpanel.yml')['mixpanel']

client = Mixpanel::Client.new(config)

data = client.request do
  resource 'events/properties'
  event    '["test-event"]'
  type     'general'
  unit     'hour'
  name     'test'
end

puts data.inspect
