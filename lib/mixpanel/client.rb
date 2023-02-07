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
    BASE_URI   = 'https://mixpanel.com/api/2.0'.freeze
    DATA_URI   = 'https://data.mixpanel.com/api/2.0'.freeze
    IMPORT_URI = 'https://api.mixpanel.com'.freeze

    attr_reader :uri
    attr_accessor :api_secret, :timeout

    def self.base_uri_for_resource(resource)
      if resource == 'export'
        DATA_URI
      elsif resource == 'import'
        IMPORT_URI
      else
        BASE_URI
      end
    end

    # Configure the client
    #
    # @example
    #   config = {api_secret: '456'}
    #   client = Mixpanel::Client.new(config)
    #
    # @param [Hash] config consisting of an 'api_secret' and additonal options
    def initialize(config)
      @api_secret = config[:api_secret]
      @timeout    = config[:timeout] || nil

      raise ConfigurationError, 'api_secret is required' if @api_secret.nil?
    end

    # Return mixpanel data as a JSON object or CSV string
    #
    # @example
    #   data = client.request(
    #     'events/properties',
    #     event:    '["test-event"]',
    #     name:     'hello',
    #     values:   '["uno", "dos"]',
    #     type:     'general',
    #     unit:     'hour',
    #     interval: 24,
    #     limit:    5,
    #     bucket:   'contents'
    #   )
    #
    # @resource [String] mixpanel api resource endpoint
    # @options  [Hash] options variables used to make a specific request for
    #           mixpanel data
    # @return   [JSON, String] mixpanel response as a JSON object or CSV string
    def request(resource, options)
      @uri = request_uri(resource, options)

      response = URI.get(@uri, @timeout, @api_secret)

      if %w(export import).include?(resource) && @format != 'raw'
        response = %([#{response.split("\n").join(',')}])
      end

      Utils.to_hash(response, @format)
    end

    # Return mixpanel URI to the data
    #
    # @example
    #   uri = client.request_uri(
    #     'events/properties',
    #     event:    '["test-event"]',
    #     name:     'hello',
    #     values:   '["uno", "dos"]',
    #     type:     'general',
    #     unit:     'hour',
    #     interval: 24,
    #     limit:    5,
    #     bucket:   'contents'
    #   )
    #
    # @resource [String] mixpanel api resource endpoint
    # @options  [Hash] options variables used to make a specific request for
    #           mixpanel data
    # @return   [JSON, String] mixpanel response as a JSON object or CSV string
    def request_uri(resource, options = {})
      @format = options[:format] || :json
      URI.mixpanel(resource, normalize_options(options))
    end

    private

    # Return a hash of options along with defaults and a generated signature
    #
    # @return [Hash] collection of options including defaults and generated
    #         signature
    def normalize_options(options)
      normalized_options = options.dup
      normalized_options.merge!(format: @format)
    end
  end
end
