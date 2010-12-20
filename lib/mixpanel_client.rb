#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details.
#
# Inspired by the official mixpanel php and python libraries.
# http://mixpanel.com/api/docs/guides/api/

require 'cgi'
require 'digest/md5'
require 'open-uri'
require 'json' unless defined?(JSON)

# Ruby library for the mixpanel.com web service
module Mixpanel
  BASE_URI = 'http://mixpanel.com/api'
  VERSION  = '2.0'

  # The mixpanel client can be used to easily consume data through the mixpanel API
  class Client
    OPTIONS = [:resource, :event, :funnel, :name, :type, :unit, :interval, :limit, :format, :bucket]
    attr_reader :uri
    attr_accessor :api_key, :api_secret

    OPTIONS.each do |option|
      class_eval "
        def #{option}(arg=nil)
          arg ? @#{option} = arg : @#{option}
        end
      "
    end

    def initialize(config)
      @api_key    = config['api_key']
      @api_secret = config['api_secret']
    end

    def params
      OPTIONS.inject({}) do |params, param|
        params.merge!(param => send(param)) if param != :resource && !send(param).nil?
        params
      end
    end

    def request(deprecated_endpoint=nil, deprecated_meth=nil, deprecated_params=nil, &options)
      reset_options
      if block_given?
        instance_eval &options
        @uri = URI.mixpanel(resource, normalize_params(params))
        response = URI.get(@uri)
        to_hash(response)
      else
        warn 'This usage is deprecated. Please use the new block form (see README).'
        @uri = URI.deprecated_mixpanel(deprecated_endpoint, deprecated_meth, normalize_params(deprecated_params))
        response = URI.get(@uri)
        to_hash(response)
      end
    end

    def normalize_params(params)
      params.merge!(
        :api_key => @api_key,
        :expire  => Time.now.to_i + 600 # Grant this request 10 minutes
      ).merge!(:sig => generate_signature(params))
    end

    def generate_signature(args)
      Digest::MD5.hexdigest(args.map{|key,val| "#{key}=#{val}"}.sort.join + api_secret)
    end

    def to_hash(data)
      if @format == 'csv'
        data
      else
        JSON.parse(data)
      end
    end

    def reset_options
      (OPTIONS - [:resource]).each do |option|
        eval "remove_instance_variable(:@#{option}) if defined?(@#{option})"
      end
    end
  end

  # URI related helpers
  class URI
    class HTTPError < StandardError; end

    def self.deprecated_mixpanel(endpoint, meth, params)
      File.join([BASE_URI, VERSION, endpoint.to_s, meth.to_s].reject(&:empty?)) + "?#{self.encode(params)}"
    end

    def self.mixpanel(resource, params)
      File.join([BASE_URI, VERSION, resource.to_s]) + "?#{self.encode(params)}"
    end

    def self.encode(params)
      params.map{|key,val| "#{key}=#{CGI.escape(val.to_s)}"}.sort.join('&')
    end

    def self.get(uri)
      ::URI.parse(uri).read
    rescue OpenURI::HTTPError => error
      raise HTTPError, JSON.parse(error.io.read)['error']
    end
  end
end
