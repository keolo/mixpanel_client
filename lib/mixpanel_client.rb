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
    attr_accessor :api_key, :api_secret

    def initialize(config)
      @api_key    = config[:api_key]
      @api_secret = config[:api_secret]
    end

    def request(endpoint, meth, params)
      uri = URI.mixpanel(endpoint, meth, normalize_params(params))
      response = URI.get(uri)
      to_hash(response)
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
      %Q(#{BASE_URI}/#{VERSION}/#{endpoint}/#{meth}?#{self.encode(params)})
    end

    def self.encode(params)
      params.map{|key,val| "#{key}=#{CGI.escape(val.to_s)}"}.sort.join('&')
    end

    def self.get(uri)
      ::URI.parse(uri).read
    end
  end
end
