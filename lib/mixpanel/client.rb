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

    # Available options for a Mixpanel API request
    OPTIONS = [:resource, :event, :events, :funnel_id, :name, :type, :unit, :interval, :limit, 
               :format, :bucket, :values, :from_date, :to_date, :on, :where, :buckets, :timezone]

    # Dynamically define accessor methods for each option
    OPTIONS.each do |option|
      class_eval "
        def #{option}(arg=nil)
          arg ? @#{option} = arg : @#{option}
        end
      "
    end

    # Configure the client
    #
    # @example
    #   config = {'api_key' => '123', 'api_secret' => '456'}
    #   client = Mixpanel::Client.new(config)
    #
    # @param [Hash] config consisting of an 'api_key' and an 'api_secret'
    def initialize(config)
      @api_key    = config['api_key']
      @api_secret = config['api_secret']
    end

    # Return mixpanel data as a JSON object or CSV string
    #
    # @example
    #   data = client.request do
    #     resource 'events/properties'
    #     event    '["test-event"]'
    #     name     'hello'
    #     values   '["uno", "dos"]'
    #     type     'general'
    #     unit     'hour'
    #     interval  24
    #     limit     5
    #     bucket   'contents'
    #   end
    #
    # @param  [Block] options variables used to make a specific request for mixpanel data
    # @return [JSON, String] mixpanel response as a JSON object or CSV string
    def request(&options)
      reset_options
      instance_eval(&options)
      @uri = URI.mixpanel(resource, normalize_params(params))
      response = URI.get(@uri)
      response = %Q|[#{response.split("\n").join(',')}]| if resource == 'export'
      Utils.to_hash(response, @format)
    end

    private

    # Reset options so we can reuse the Mixpanel::Client object without the options persisting
    # between requests
    def reset_options
      (OPTIONS - [:resource]).each do |option|
        eval "remove_instance_variable(:@#{option}) if defined?(@#{option})"
      end
    end

    # Return a hash of options for a given request
    #
    # @return [Hash] collection of options passed in from the request method
    def params
      OPTIONS.inject({}) do |params, param|
        option = send(param)
        params.merge!(param => option) if param != :resource && !option.nil?
        params
      end
    end

    # Return a hash of options along with defaults and a generated signature
    #
    # @return [Hash] collection of options including defaults and generated signature
    def normalize_params(params)
      params.merge!(
        :api_key => @api_key,
        :expire  => Time.now.to_i + 600 # Grant this request 10 minutes
      ).merge!(:sig => Utils.generate_signature(params, @api_secret))
    end
    
    def self.base_uri_for_resource(resource)
      resource == 'export' ? DATA_URI : BASE_URI
    end
  end
end
