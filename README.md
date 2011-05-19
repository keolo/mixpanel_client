# Mixpanel API Client (for API version 2.0)

Ruby access to the [Mixpanel](http://mixpanel.com/) web analytics tool.


## Installation

    gem install mixpanel_client


## Usage

    require 'rubygems'
    require 'mixpanel_client'

    client = Mixpanel::Client.new('api_key' => 'changeme', 'api_secret' => 'changeme')

    data = client.request do
      resource 'events/properties'
      event    '["test-event"]'
      name     'hello'
      values   '["uno", "dos"]'
      type     'general'
      unit     'hour'
      interval  24
      limit     5
      bucket   'kicked'
    end

    puts data.inspect

## Changelog

### 2.0.0.beta1
 * Reverted to namespacing via module name because it's a better practice.
   I.e. Use `Mixpanel::Client` instead of `MixpanelClient`.
 * Added 'values' as an optional parameter

### 1.0.1
 * Minor housekeeping and organizing
 * Refactored specs

### 1.0.0
 * Changed "Mixpanel" class name to "MixpanelClient" to prevent naming collision in other 
   libraries. [a710a84e8ba4b6f018b7](https://github.com/keolo/mixpanel_client/commit/a710a84e8ba4b6f018b7404ab9fabc8f08b4a4f3)

## Collaborators and Maintainers
[Keolo Keagy](http://github.com/keolo) (Author)  
[Nathan Chong](http://github.com/paramaw)  
[Paul McMahon](http://github.com/pwim)  
[Chad Etzel](http://github.com/jazzychad)

## Copyright

Copyright (c) 2009+ Keolo Keagy. See LICENSE for details.
