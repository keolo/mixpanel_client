#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details.
# Open sourced by the good folks at SharesPost.com
#
# Inspired by the official mixpanel php and python libraries.
# http://mixpanel.com/api/docs/guides/api/

require 'cgi'
require 'digest/md5'
require 'open-uri'

module Mixpanel
  class Client
    attr_accessor :api_key, :api_secret, :format

    BASE_URI = 'http://mixpanel.com/api'
    VERSION  = '1.0'

    def initialize(config)
      @api_key    = config[:api_key]
      @api_secret = config[:api_secret]
      @format   ||= :json
    end

    def request(endpoint, meth, params)
      params[:api_key]  = api_key
      params[:expire]   = Time.now.to_i + 600 # Grant this request 10 minutes
      params[:format] ||= @format
      params[:sig]      = hash_args(params)

      @sig    = params[:sig]
      @format = params[:format]

      response = get(mixpanel_uri(endpoint, meth, params))
      to_hash(response)
    end

    def hash_args(args)
      Digest::MD5.hexdigest(args.map{|k,v| "#{k}=#{v}"}.sort.to_s + api_secret)
    end

    def get(uri)
      URI.parse(uri).read
    end

    def mixpanel_uri(endpoint, meth, params)
      %Q(#{BASE_URI}/#{endpoint}/#{VERSION}/#{meth}?#{urlencode(params)})
    end

    def urlencode(params)
      params.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.sort.join('&')
    end

    def to_hash(data)
      case @format
      when :placeholder
        # This is just a placeholder in case Mixpanel supports alternate
        # formats. Mixpanel at this time (v1.0) only supports JSON.
      else # The default response is JSON
        require 'json' unless defined?(JSON)
        JSON.parse(data)
      end
    end
  end
end
