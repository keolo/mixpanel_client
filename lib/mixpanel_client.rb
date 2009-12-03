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
require 'rubygems'
require 'json'

module Mixpanel
  class Client
    attr_accessor :api_key, :api_secret

    BASE_URI = 'http://mixpanel.com/api'
    VERSION  = '1.0'

    def initialize(config)
      @api_key    = config[:api_key]
      @api_secret = config[:api_secret]
    end

    def request(endpoint, meth, params)
      params[:api_key]  = api_key
      params[:expire]   = Time.now.to_i + 600 # Grant this request 10 minutes
      params[:format] ||= :json
      params[:sig]      = hash_args(params)

      @format = params[:format]

      response = URI.parse(mixpanel_uri(endpoint, meth, params)).read
      to_hash(response)
    end

    def hash_args(args)
      Digest::MD5.hexdigest(args.map{|k,v| "#{k}=#{v}"}.sort.to_s + api_secret)
    end

    def mixpanel_uri(endpoint, meth, params)
      %Q(#{BASE_URI}/#{endpoint}/#{VERSION}/#{meth}?#{urlencode(params)})
    end

    def urlencode(params)
      params.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.sort.join('&')
    end

    protected
      def to_hash(data)
        case @format
        when :json
          JSON.parse(data)
        end
      end
  end
end
