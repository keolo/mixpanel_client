# Mixpanel API Client (for API version 2.0)

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.


## Installation

    gem install mixpanel_client


## Usage

    require 'rubygems'
    require 'mixpanel_client'

    client = Mixpanel::Client.new('api_key' => 'changeme', 'api_secret' => 'changeme')

    data = client.request do
      resource 'events/retention'
      event    '["test-event"]'
      type     'general'
      unit     'hour'
      interval  24
      bucket   'test'
    end

    puts data.inspect

## Copyright

Copyright (c) 2009+ Keolo Keagy. See LICENSE for details.
