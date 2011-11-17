#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Define exceptions for this library
#
# Copyright (c) 2009+ Keolo Keagy
# See LICENSE for details
module Mixpanel
  # URI related exceptions
  class Error < StandardError; end
  class HTTPError < Error; end
  class ParseError < Error; end
end
