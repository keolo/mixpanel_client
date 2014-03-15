$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'mixpanel_client'
require 'yaml'

config = YAML.load_file(File.dirname(__FILE__) + '/../config/mixpanel.yml')['mixpanel']

client = Mixpanel::Client.new({api_key: config[:api_key], api_secret: config[:api_secret]})

data = client.request('events/properties', {
  event:    '["test-event"]',
  type:     'general',
  unit:     'hour',
  name:     'test'
})

puts data.inspect
