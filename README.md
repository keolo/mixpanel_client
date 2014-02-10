# Mixpanel API Client (for API version 2.0)

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.

[Mixpanel Data API Reference](https://mixpanel.com/docs/api-documentation/data-export-api)

## Installation

    gem install mixpanel_client
    
or if you use a Gemfile

    gem 'mixpanel_client'

## Usage

    require 'rubygems'
    require 'mixpanel_client'

    config = {api_key: 'changeme', api_secret: 'changeme'}
    client = Mixpanel::Client.new(config)

    data = client.request('events/properties', {
      event:     'splash features',
      name:      'feature',
      values:    '["uno", "dos"]',
      type:      'unique',
      unit:      'day',
      interval:   7,
      limit:      5,
    })

    puts data.inspect


    # use the import API, which allows one to specify a time in the past, unlike the track API. note that you need to include your api token in the data.
    # See https://mixpanel.com/docs/api-documentation/importing-events-older-than-31-days for all the details.
    data_to_import = {'event' => 'firstLogin', 'properties' => {'distinct_id' => guid, 'time' => time_as_integer_seconds_since_epoch, 'token' => api_token}}
    require 'base64' # co-located with the Base64 call below for clarity
    encoded_data = Base64.encode64(data_to_import.to_json)
    data = client.request('import', {:data => encoded_data, :api_key => api_key})
    # data == [1] # => true # you can only import one event at a time

## Parallel

    require 'rubygems'
    require 'mixpanel_client'

    config = {api_key: 'changeme', api_secret: 'changeme', parallel: true}    
    client = Mixpanel::Client.new(config)

    first_request = client.request('events/properties', {
    ...
    })

    second_request = client.request('events/properties', {
    ...
    })

    third_request = client.request('events/properties', {
    ...
    })

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

## Releasing Gem
Update version
  
    vi lib/mixpanel/version.rb

Commit and push local changes
    
    git commit -am "Some message."
    git push
    git status

Create tag v2.0.2 and build and push mixpanel_client-2.0.2.gem to Rubygems
  
    rake release


## Changelog

### v3.1.3
 * 	Added support for the import API.

### v3.1.2
 * Gem updates

### v3.1.1
 * Avoid overriding the arg of client.request
 * Allow retrieving the request_uri of a Mixpanel request

### v3.1.0
 * Parallel requests option.

### v3.0.0
 * NOTE: This version breaks backwards compatibility.
 * Use a regular ruby hash instead of metaprogramming for mixpanel options.

### v2.2.3
 * 	Added some more options.

### v2.2.2
 * 	Added some more options.

### v2.2.1
 * 	Added support for the raw data export API.

### v2.2.0
  * BASE_URI is now https.
  * Changed funnel to funnel_id.

### v2.1.0
 * Updated json dependency to 1.6.

### v2.0.2
 * Added timezone to available options.
 * All exceptions can be caught under Mixpanel::Error.

### v2.0.1
 * Added options used in segmentation resources.

### v2.0.0
 * Manually tested compatibility with Mixpanel gem. 

### v2.0.0.beta2
 * Added JSON to gemspec for ruby versions less than 1.9.

### v2.0.0.beta1
 * Reverted to namespacing via module name because it's a better practice.
   I.e. Use `Mixpanel::Client` instead of `MixpanelClient`.
 * Added 'values' as an optional parameter
 * `gem install mixpanel_client --pre`

### v1.0.1
 * Minor housekeeping and organizing
 * Refactored specs

### v1.0.0
 * Changed "Mixpanel" class name to "MixpanelClient" to prevent naming collision in other 
   libraries. [a710a84e8ba4b6f018b7](https://github.com/keolo/mixpanel_client/commit/a710a84e8ba4b6f018b7404ab9fabc8f08b4a4f3)

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

Copyright (c) 2009+ Keolo Keagy. See LICENSE for details.
