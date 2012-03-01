# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mixpanel::URI do
  describe '.mixpanel' do
    it 'should return a properly formatted mixpanel uri as a string (without an endpoint)' do
      resource, params  = ['events', {:c => 'see', :a => 'ey'}]
      Mixpanel::URI.mixpanel(resource, params).should == "#{Mixpanel::Client::BASE_URI}/events?a=ey&c=see"
    end
    it 'should return a properly formatted mixpanel uri as a string (with an endpoint)' do
      resource, params  = ['events/top', {:c => 'see', :a => 'ey'}]
      Mixpanel::URI.mixpanel(resource, params).should == "#{Mixpanel::Client::BASE_URI}/events/top?a=ey&c=see"
    end
    it 'should return a uri with a different endpoint when doing a raw data export' do
      resource, params  = ['export', {:c => 'see', :a => 'ey'}]
      Mixpanel::URI.mixpanel(resource, params).should == "#{Mixpanel::Client::DATA_URI}/export?a=ey&c=see"
    end
  end

  describe '.encode' do
    it 'should return a string with url encoded values.' do
      params = {:hey => '!@#$%^&*()\/"Ü', :soo => "hëllö?"}
      Mixpanel::URI.encode(params).should == 'hey=%21%40%23%24%25%5E%26%2A%28%29%5C%2F%22%C3%9C&soo=h%C3%ABll%C3%B6%3F'
    end
  end

  describe '.get' do
    it 'should return a string response' do
      stub_request(:get, 'http://example.com').to_return(:body => 'something')
      Mixpanel::URI.get('http://example.com').should == 'something'
    end
  end
end
