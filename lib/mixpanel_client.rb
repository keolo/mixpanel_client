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

# Ruby library for the mixpanel.com web service
module Mixpanel
  BASE_URI = 'http://mixpanel.com/api'
  VERSION  = '2.0'

  # The mixpanel client can be used to easily consume data through the
  # mixpanel API.
  class Client
    attr_reader :uri
    attr_accessor :api_key, :api_secret

    def initialize(config)
      @api_key    = config['api_key']
      @api_secret = config['api_secret']
    end

    [:endpoint, :method, :event, :unit, :interval, :type].each do |attr|
      class_eval "
        def #{attr}(arg=nil)
          arg ? @#{attr} = arg : @#{attr}
        end
      "
    end

    def request(deprecated_endpoint=nil, deprecated_meth=nil, deprecated_params=nil, &options)
      if block_given?
        instance_eval &options
        params = {:event => event, :unit => unit, :interval => interval, :type => type}.delete_if{|k,v| v.nil?}
        @uri = URI.mixpanel(endpoint, method, normalize_params(params))
        response = URI.get(@uri)
        to_hash(response)
      else
        warn 'This usage is deprecated. Please use the block form (see README).'
        @uri = URI.mixpanel(deprecated_endpoint, deprecated_meth, normalize_params(deprecated_params))
        response = URI.get(@uri)
        to_hash(response)
      end
    end

    def normalize_params(params)
      params.merge!(
        :api_key => api_key,
        :expire  => Time.now.to_i + 600, # Grant this request 10 minutes
        :format  => :json
      ).merge!(:sig => hash_args(params))
    end

    def hash_args(args)
      Digest::MD5.hexdigest(args.map{|key,val| "#{key}=#{val}"}.sort.join + api_secret)
    end

    def to_hash(data)
      require 'json' unless defined?(JSON)
      JSON.parse(data)
    end
  end

  # URI related helpers
  class URI
    def self.mixpanel(endpoint, meth, params)
      File.join([BASE_URI, VERSION, endpoint.to_s, meth.to_s].reject(&:empty?)) + "?#{self.encode(params)}"
    end

    def self.encode(params)
      params.map{|key,val| "#{key}=#{CGI.escape(val.to_s)}"}.sort.join('&')
    end

    def self.get(uri)
      ::URI.parse(uri).read
    end
  end
end

class Object
  # There's got to be a better way to do this!!
  def instance_values
    self.instance_variables.map{|var| var_sym = var.to_s.gsub('@','').to_sym; {var_sym => self.send(var_sym)}}
  end
end
