# Mixpanel Data API Client

[![Gem Version](https://badge.fury.io/rb/mixpanel_client.png)](http://badge.fury.io/rb/mixpanel_client)

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.

[Mixpanel Data API Reference](https://mixpanel.com/docs/api-documentation/data-export-api)

## Installation

    gem install mixpanel_client
    
or if you use a Gemfile

    gem 'mixpanel_client'

## Usage

    require 'rubygems'
    require 'mixpanel_client'

    client = Mixpanel::Client.new(
      api_key:    'changeme', 
      api_secret: 'changeme'
    )

    data = client.request(
      'events/properties',
      event:     'splash features',
      name:      'feature',
      values:    '["uno", "dos"]',
      type:      'unique',
      unit:      'day',
      from_date: '2013-12-1',
      to_date:   '2014-3-1',
      limit:     5
    )

    puts data.inspect

    # The API also supports passing a time interval rather than an explicit date range
    data = client.request(
      'events/properties',
      event:    'splash features',
      name:     'feature',
      values:   '["uno", "dos"]',
      type:     'unique',
      unit:     'day',
      interval: 7,
      limit:    5
    )


    # use the import API, which allows one to specify a time in the past, unlike the track API.
    # note that you need to include your api token in the data. More details at:
    # https://mixpanel.com/docs/api-documentation/importing-events-older-than-31-days
    data_to_import = {'event' => 'firstLogin', 'properties' => {'distinct_id' => guid, 'time' => time_as_integer_seconds_since_epoch, 'token' => api_token}}
    require 'base64' # co-located with the Base64 call below for clarity
    encoded_data = Base64.encode64(data_to_import.to_json)
    data = client.request('import', {:data => encoded_data, :api_key => api_key})
    # data == [1] # => true # you can only import one event at a time

## Parallel

You may also make requests in parallel by passing in the `parallel: true` option.

    require 'rubygems'
    require 'mixpanel_client'

    client = Mixpanel::Client.new(
      api_key:    'changeme', 
      api_secret: 'changeme',
      parallel:   true
    )

    first_request = client.request(
      'events/properties',
      ...
    )

    second_request = client.request(
      'events/properties',
      ...
    )

    third_request = client.request(
      'events/properties',
      ...
    )

    ...
    
    client.run_parallel_requests
    
    puts first_request.response.handled_response
    puts second_request.response.handled_response
    puts third_request.response.handled_response    
    

## Development
List of rake tasks.

    rake -T

Run specs.

    rake spec

Run external specs.

    cp config/mixpanel.template.yml config/mixpanel.yml
    vi config/mixpanel.yml
    rake spec:externals

Run rubocop and fix offences.

    rubocop


## Changelog
[Changelog](changelog.md)


## Collaborators and Maintainers
Feel free to add your name and link here.

[Keolo Keagy](http://github.com/keolo) (Author)  
[Hiroshige Umino](https://github.com/yaotti)  
[Gabor Ratky](https://github.com/rgabo)  
[Bill DeRusha](https://github.com/bderusha)  
[Jason Logsdon](https://github.com/jasonlogsdon)  
[James R](https://github.com/Cev)  
[Mike Ferrier](http://github.com/mferrier)  
[Grzegorz Forysinski](http://github.com/railwaymen)  
[Nathan Chong](http://github.com/paramaw)  
[Paul McMahon](http://github.com/pwim)  
[Chad Etzel](http://github.com/jazzychad)  
[Kevin Burnett](http://github.com/burnettk)  

## Copyright

Copyright (c) 2009+ Keolo Keagy. See [license](license) for details.
