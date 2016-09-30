$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'mixpanel_client'
require 'yaml'
require 'typhoeus'

config = YAML.load_file(
  File.join(
    File.dirname(__FILE__),
    '..',
    'config',
    'mixpanel.yml'
  )
)['mixpanel']

client = Mixpanel::Client.new(
  api_key:    config[:api_key],
  api_secret: config[:api_secret],
  parallel:   true
)

uno = client.request(
  'events/top',
  type: 'general'
)

dos = client.request(
  'events/names',
  type: 'general'
)

client.run_parallel_requests

puts uno.response.handled_response.inspect
puts dos.response.handled_response.inspect
