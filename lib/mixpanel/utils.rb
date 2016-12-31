#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Allows access to the mixpanel.com api using the ruby programming language
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details
module Mixpanel
  # Utility methods for Mixpanel::Client
  class Client
    # Mixpanel API Ruby Client Library
    #
    # Utility helpers
    #
    # Copyright (c) 2009+ Keolo Keagy
    # See LICENSE for details
    module Utils
      # Return a JSON object or a string depending on a given format
      #
      # @param [String] data either CSV or JSON formatted
      # @return [JSON, String] data
      def self.to_hash(data, format)
        if format == 'csv' || format == 'raw'
          data
        else
          begin
            JSON.parse(data)
          rescue JSON::ParserError => error
            raise ParseError, error
          end
        end
      end
    end
  end
end
