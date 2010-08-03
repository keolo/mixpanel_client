require 'rubygems'

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mixpanel::Client do
  before :all do
    config = {:api_key => 'test', :api_secret => 'test'}
    @api = Mixpanel::Client.new(config)
  end

  describe '#request' do
    it 'should return json and convert to a ruby hash' do
      # Stub Mixpanel web service
      Mixpanel::URI.stub!(:get).and_return('{"some" : "thing"}')

      data = @api.request(:events, :general, {
        :event    => '["test-event"]',
        :unit     => 'hour',
        :interval =>  24
      })
      data.should == {'some' => 'thing'}
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
  describe '.mixpanel' do
    it 'should return a properly formatted mixpanel uri as a string' do
      endpoint, meth, params  = [:events, :general, {:c => 'see', :a => 'aye'}]
      Mixpanel::URI.mixpanel(endpoint, meth, params).should == 'http://mixpanel.com/api/2.0/events/general?a=aye&c=see'
    end
  end

  describe '.encode' do
    it 'should return a string with url encoded values.' do
      params = {:hey => '!@#$%^&*()\/"Ü', :soo => "hëllö?"}
      Mixpanel::URI.encode(params).should == 'hey=%21%40%23%24%25%5E%26%2A%28%29%5C%2F%22%C3%9C&soo=h%C3%ABll%C3%B6%3F'
    end
  end
end
