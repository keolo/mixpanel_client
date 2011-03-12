#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details.
#
# Inspired by the official mixpanel php and python libraries.
# http://mixpanel.com/api/docs/guides/api/

# URI related helpers
class MixpanelClient::URI
  # Create an http error class for us to use
  class HTTPError < StandardError; end

  def self.mixpanel(resource, params)
    File.join([MixpanelClient::BASE_URI, MixpanelClient::VERSION, resource.to_s]) + "?#{self.encode(params)}"
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
