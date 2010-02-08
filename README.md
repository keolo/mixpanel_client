# Ruby Mixpanel API Client

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.

## Installation
    $ gem install mixpanel_client

## Example Usage
    require 'rubygems'
    require 'json'
    require 'mixpanel_client'

    config = {:api_key => 'changeme', :api_secret => 'changeme'}

    api = Mixpanel::Client.new(config)

    data = api.request(:events, :general, {
      :event    => '["test-event"]',
      :unit     => 'hour',
      :interval =>  24
    })

    puts data.inspect

## Copyright

Copyright (c) 2009 Keolo Keagy. See LICENSE for details.
