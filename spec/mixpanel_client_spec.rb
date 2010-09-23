require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mixpanel::Client do
  before :all do
    config = {'api_key' => 'test', 'api_secret' => 'test'}
    @api = Mixpanel::Client.new(config)
  end

  describe '#request' do
    it 'should return json and convert to a ruby hash' do
      uri = Regexp.escape(Mixpanel::BASE_URI)

      # Stub Mixpanel request
      stub_request(:get, /^#{uri}.*/).to_return(:body => '{"legend_size": 0, "data": {"series": [], "values": {}}}')

      data = @api.request(nil, :events, {
        :event    => '["test-event"]',
        :unit     => 'hour',
        :interval =>  24
      })

      data.should == {"data"=>{"series"=>[], "values"=>{}}, "legend_size"=>0}
    end
  end

  describe 'block form' do
    it 'should work without an endpoint' do
      uri = Regexp.escape(Mixpanel::BASE_URI)

      # Stub Mixpanel request
      stub_request(:get, /^#{uri}.*/).to_return(:body => '{"legend_size": 0, "data": {"series": [], "values": {}}}')

      # No endpoint
      data = @api.request do
        resource 'events'
        event    '["test-event"]'
        unit     'hour'
        interval  24
      end
      data.should == {"data"=>{"series"=>[], "values"=>{}}, "legend_size"=>0}
    end

    it 'should work with an endpoint, method, and type' do
      uri = Regexp.escape(Mixpanel::BASE_URI)

      # Stub Mixpanel request
      stub_request(:get, /^#{uri}.*/).to_return(:body => '{"events": [], "type": "general"}')

      # With endpoint
      data = @api.request do
        resource 'events/top'
        type     'general'
      end
      data.should == {"events"=>[], "type"=>"general"}
    end
  end

  describe '#hash_args' do
    it 'should return a hashed string alpha sorted by key names.' do
      args              = {:c => 'see', :a => 'aye', :d => 'dee', :b => 'bee'}
      args_alpha_sorted = {:a => 'aye', :b => 'bee', :c => 'see', :d => 'dee'}
      @api.hash_args(args).should == @api.hash_args(args_alpha_sorted)
    end
  end

  describe '#to_hash' do
    it 'should return a ruby hash given json as a string' do
      @api.to_hash('{"a" : "aye", "b" : "bee"}').should == {'a' => 'aye', 'b' => 'bee'}
    end
  end
end

describe Mixpanel::URI do
  describe '.deprecated_mixpanel' do
    it 'should return a properly formatted mixpanel uri as a string (without an endpoint)' do
      endpoint, meth, params  = [:events, nil, {:c => 'see', :a => 'aye'}]
      Mixpanel::URI.deprecated_mixpanel(endpoint, meth, params).should == 'http://mixpanel.com/api/2.0/events?a=aye&c=see'
    end
    it 'should return a properly formatted mixpanel uri as a string (with an endpoint)' do
      endpoint, meth, params  = [:events, :top, {:c => 'see', :a => 'aye'}]
      Mixpanel::URI.deprecated_mixpanel(endpoint, meth, params).should == 'http://mixpanel.com/api/2.0/events/top?a=aye&c=see'
    end
  end

  describe '.mixpanel' do
    it 'should return a properly formatted mixpanel uri as a string (without an endpoint)' do
      resource, params  = ['events', {:c => 'see', :a => 'aye'}]
      Mixpanel::URI.mixpanel(resource, params).should == 'http://mixpanel.com/api/2.0/events?a=aye&c=see'
    end
    it 'should return a properly formatted mixpanel uri as a string (with an endpoint)' do
      resource, params  = ['events/top', {:c => 'see', :a => 'aye'}]
      Mixpanel::URI.mixpanel(resource, params).should == 'http://mixpanel.com/api/2.0/events/top?a=aye&c=see'
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
