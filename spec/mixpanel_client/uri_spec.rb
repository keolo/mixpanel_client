# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MixpanelClient::URI do
  describe '.mixpanel' do
    it 'should return a properly formatted mixpanel uri as a string (without an endpoint)' do
      resource, params  = ['events', {:c => 'see', :a => 'aye'}]
      MixpanelClient::URI.mixpanel(resource, params).should == 'http://mixpanel.com/api/2.0/events?a=aye&c=see'
    end
    it 'should return a properly formatted mixpanel uri as a string (with an endpoint)' do
      resource, params  = ['events/top', {:c => 'see', :a => 'aye'}]
      MixpanelClient::URI.mixpanel(resource, params).should == 'http://mixpanel.com/api/2.0/events/top?a=aye&c=see'
    end
  end

  describe '.encode' do
    it 'should return a string with url encoded values.' do
      params = {:hey => '!@#$%^&*()\/"Ü', :soo => "hëllö?"}
      MixpanelClient::URI.encode(params).should == 'hey=%21%40%23%24%25%5E%26%2A%28%29%5C%2F%22%C3%9C&soo=h%C3%ABll%C3%B6%3F'
    end
  end

  describe '.get' do
    it 'should return a string response' do
      stub_request(:get, 'http://example.com').to_return(:body => 'something')
      MixpanelClient::URI.get('http://example.com').should == 'something'
    end
  end
end
