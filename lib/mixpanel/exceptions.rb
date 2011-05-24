# Define exceptions for this library
module Mixpanel
  class Client::ArgumentError  < ArgumentError; end
  class URI::HTTPError < StandardError; end
end
