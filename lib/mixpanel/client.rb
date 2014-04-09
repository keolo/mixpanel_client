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
    BASE_URI   = 'https://mixpanel.com/api/2.0'
    DATA_URI   = 'https://data.mixpanel.com/api/2.0'
    IMPORT_URI = 'https://api.mixpanel.com'

    attr_reader   :uri
    attr_accessor :api_key, :api_secret, :parallel

    # Configure the client
    #
    # @example
    #   config = {api_key: '123', api_secret: '456'}
    #   client = Mixpanel::Client.new(config)
    #
    # @param [Hash] config consisting of an 'api_key' and an 'api_secret'
    def initialize(config)
      @api_key    = config[:api_key]
      @api_secret = config[:api_secret]
      @parallel   = config[:parallel]   || false

      fail ConfigurationError if @api_key.nil? || @api_secret.nil?
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
      @parallel ? make_parallel_request : make_normal_request(resource)
    end

    def make_parallel_request
      parallel_request = prepare_parallel_request
      hydra.queue parallel_request
      parallel_request
    end

    def make_normal_request(resource)
      response = URI.get(@uri)

      if %w(export import).include?(resource)
        response = %Q([#{response.split("\n").join(',')}])
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
    def request_uri(resource, options)
      @format = options[:format] || :json
      URI.mixpanel(resource, normalize_options(options))
    end

    # rubocop:disable MethodLength
    def prepare_parallel_request
      request = ::Typhoeus::Request.new(@uri)

      request.on_complete do |response|
        if response.success?
          Utils.to_hash(response.body, @format)
        elsif response.timed_out?
          fail TimeoutError
        elsif response.code == 0
          # Could not get an http response, something's wrong
          fail HTTPError, response.curl_error_message
        else
          # Received a non-successful http response
          if response.body && response.body != ''
            error_message = JSON.parse(response.body)['error']
          else
            error_message = response.code.to_s
          end

          fail HTTPError, error_message
        end
      end

      request
    end
    # rubocop:enable MethodLength

    def run_parallel_requests
      hydra.run
    end

    def hydra
      @hydra ||= ::Typhoeus::Hydra.new
    end

    private

    # Return a hash of options along with defaults and a generated signature
    #
    # @return [Hash] collection of options including defaults and generated
    #         signature
    def normalize_options(options)
      normalized_options = options.dup

      normalized_options
        .merge!(
          format:  @format,
          api_key: @api_key,
          expire:  request_expires_at(normalized_options)
        )
        .merge!(
          sig: Utils.generate_signature(normalized_options, @api_secret)
        )
    end

    def request_expires_at(options)
      ten_minutes_from_now = Time.now.to_i + 600
      options[:expire] ? options[:expire].to_i : ten_minutes_from_now
    end

    def self.base_uri_for_resource(resource)
      if resource == 'export'
        DATA_URI
      elsif resource == 'import'
        IMPORT_URI
      else
        BASE_URI
      end
    end
  end
end
