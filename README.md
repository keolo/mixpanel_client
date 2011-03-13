# Mixpanel API Client (for API version 2.0)

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.


## Installation

    gem install mixpanel_client


## Usage

    require 'rubygems'
    require 'mixpanel_client'

    client = MixpanelClient.new('api_key' => 'changeme', 'api_secret' => 'changeme')

    data = client.request do
      resource 'events/retention'
      event    '["test-event"]'
      type     'general'
      unit     'hour'
      interval  24
      bucket   'test'
    end

    puts data.inspect

## Changelog

### 0.6.0
 * Changed "Mixpanel" class name to "MixpanelClient" to prevent naming collision in other libraries. [a710a84e8ba4b6f018b7](https://github.com/keolo/mixpanel_client/commit/a710a84e8ba4b6f018b7404ab9fabc8f08b4a4f3)

## Collaborators and Maintainers
[Keolo Keagy](http://github.com/keolo) (Author)  
[Nathan Chong](http://github.com/paramaw)  
[Paul McMahon](http://github.com/pwim)  
[Chad Etzel](http://github.com/jazzychad)

## Copyright

Copyright (c) 2009+ Keolo Keagy. See LICENSE for details.
