#!/usr/bin/env ruby -Ku

# Mixpanel API Ruby Client Library
#
# Library includes.
#
# Copyright (c) 2009+ Keolo Keagy.
# See LICENSE for details.

# Libraries.
require 'cgi'
require 'digest/md5'
require 'open-uri'
require 'json' unless defined?(JSON)

# Mixpanel::Client libraries.
require "#{File.dirname(__FILE__)}/mixpanel/client"
require "#{File.dirname(__FILE__)}/mixpanel/utils"
require "#{File.dirname(__FILE__)}/mixpanel/uri"
require "#{File.dirname(__FILE__)}/mixpanel/exceptions"
