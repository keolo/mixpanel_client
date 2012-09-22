#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Allows access to the mixpanel.com API using the ruby programming language
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details
module Mixpanel
  # Return metrics from Mixpanel Data API
  class Client
    BASE_URI = 'https://mixpanel.com/api/2.0'
    DATA_URI = 'https://data.mixpanel.com/api/2.0'

    attr_reader   :uri
    attr_accessor :api_key, :api_secret

    # Configure the client
    #
    # @example
    #   config = {'api_key' => '123', 'api_secret' => '456'}
    #   client = Mixpanel::Client.new(config)
    #
    # @param [Hash] config consisting of an 'api_key' and an 'api_secret'
    def initialize(config)
      @api_key    = config[:api_key]
      @api_secret = config[:api_secret]
    end

    # Return mixpanel data as a JSON object or CSV string
    #
    # @example
    #   data = client.request('events/properties', {
    #     event:    '["test-event"]',
    #     name:     'hello',
    #     values:   '["uno", "dos"]',
    #     type:     'general',
    #     unit:     'hour',
    #     interval:  24,
    #     limit:     5,
    #     bucket:   'contents'
    #   })
    #
    # @resource [String] mixpanel api resource endpoint
    # @options  [Hash] options variables used to make a specific request for mixpanel data
    # @return   [JSON, String] mixpanel response as a JSON object or CSV string
    def request(resource, options)
      @format = options[:format] || :json
      @uri = URI.mixpanel(resource, normalize_options(options))
      response = URI.get(@uri)
      response = %Q|[#{response.split("\n").join(',')}]| if resource == 'export'
      Utils.to_hash(response, @format)
    end

    private

    # Return a hash of options along with defaults and a generated signature
    #
    # @return [Hash] collection of options including defaults and generated signature
    def normalize_options(options)
      options.merge!(
        :format  => @format,
        :api_key => @api_key,
        :expire  => Time.now.to_i + 600 # Grant this request 10 minutes
      ).merge!(:sig => Utils.generate_signature(options, @api_secret))
    end

    def self.base_uri_for_resource(resource)
      resource == 'export' ? DATA_URI : BASE_URI
    end
  end
end
