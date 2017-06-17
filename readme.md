# Mixpanel Data API Client

[![Gem Version](https://badge.fury.io/rb/mixpanel_client.svg)](http://badge.fury.io/rb/mixpanel_client)
[![Code Climate](https://codeclimate.com/github/keolo/mixpanel_client/badges/gpa.svg)](https://codeclimate.com/github/keolo/mixpanel_client)
[ ![Codeship Status for keolo/mixpanel_client](https://codeship.com/projects/4d247060-1ad9-0134-e1c3-0e8ad2af7d49/status?branch=master)](https://codeship.com/projects/159479)

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
      api_secret: 'changeme'
      timeout: 240    # Default is 60 seconds, increase if you get frequent Net::ReadTimeout errors.
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

    # Use the import API, which allows one to specify a time in the past, unlike the track API.
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
[Contributors](https://github.com/keolo/mixpanel_client/graphs/contributors)


## Copyright

Copyright (c) 2009+ Keolo Keagy. See [license](license) for details.
