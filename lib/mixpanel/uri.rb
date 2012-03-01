#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# URI related helpers
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details
module Mixpanel
  # Utilities to assist generating and requesting URIs
  class URI
    def self.mixpanel(resource, params)
      base = Mixpanel::Client.base_uri_for_resource(resource)
      "#{File.join([base, resource.to_s])}?#{self.encode(params)}"
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
