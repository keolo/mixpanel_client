# Mixpanel API Client (for API version 2.0)

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.


## Installation

    gem install mixpanel_client


## New Usage

    require 'rubygems'
    require 'json'
    require 'mixpanel_client'

    config = {'api_key' => 'changeme', 'api_secret' => 'changeme'}

    api = Mixpanel::Client.new(config)

    # Example without an endpoint
    data = api.request do
      method   'events'
      event    '["test-event"]'
      unit     'hour'
      interval  24
    end
    puts data.inspect

    # Example with an endpoint and method
    data = api.request do
      endpoint 'events/properties'
      method   'top'
      type     'general'
    end
    puts data.inspect


## Old Usage

__NOTE: This old usage is deprecated and will be removed in future versions.__

    require 'rubygems'
    require 'json'
    require 'mixpanel_client'
    config = {:api_key => 'changeme', :api_secret => 'changeme'}

    api = Mixpanel::Client.new(config)

    # Example without an endpoint
    data = api.request(nil, :events, {
      :event    => '["test-event"]',
      :unit     => 'hour',
      :interval =>  24
    })
    puts data.inspect

    # Example with an endpoint and method
    data = api.request(:events, :top, {
      :type    => 'general'
    })
    puts data.inspect

## Copyright

Copyright (c) 2009+ Keolo Keagy. See LICENSE for details.
