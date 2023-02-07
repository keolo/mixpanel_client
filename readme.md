# Mixpanel Data API Client

[![Gem Version](https://badge.fury.io/rb/mixpanel_client.svg)](http://badge.fury.io/rb/mixpanel_client)
[![Code Climate](https://codeclimate.com/github/keolo/mixpanel_client/badges/gpa.svg)](https://codeclimate.com/github/keolo/mixpanel_client)

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
      timeout: 240, # Default is 60 seconds, increase to reduce timeout errors.

      # Optional URI overrides (e.g. https://developer.mixpanel.com/reference/overview)
      base_uri: 'api-eu.mixpanel.com',
      data_uri: 'example-data.com',
      import_uri: 'example-import.com
    )

    data = client.request(
      'events/properties',
      event:     'Product Clicked',
      name:      'product-clicked',
      values:    '["value1", "value2"]',
      type:      'unique',
      unit:      'day',
      limit:     5,
      from_date: '2013-12-1', #<- Date range
      to_date:   '2014-3-1'   #<-
    )

The API also supports passing a time interval rather than an explicit date range.

    data = client.request(
      'events/properties',
      event:    'Product Clicked',
      name:     'product-clicked',
      values:   '["value1", "value2"]',
      type:     'unique',
      unit:     'day',
      limit:    5,
      interval: 7 #<- Interval
    )

Use the Import API to specify a time in the past. You'll need to include your
API token in the data ([docs](https://mixpanel.com/docs/api-documentation/importing-events-older-than-31-days.)).

To import, encode the data as JSON and use Base64. Encode the data like this:

    data_to_import = {
        'event' => 'firstLogin', 
        'properties' => {
            'distinct_id' => guid, 
            'time' => time_as_integer_seconds_since_epoch, 
            'token' => api_token
        }
    }
    encoded_data = Base64.encode64(data_to_import.to_json)

Then make a request to the API with the given API key, passing in the encoded data:

    data = client.request('import', {:data => encoded_data, :api_key => api_key})

You can only import one event at a time.

## Parallel

The option to make parallel requests has been removed (in v5) so that there are no runtime dependencies.

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
