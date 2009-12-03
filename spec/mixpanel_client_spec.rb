require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Mixpanel::Client' do
  before :all do
    config = {:api_key => 'test', :api_secret => 'test'}
    @api = Mixpanel::Client.new(config)
  end

  describe '#request' do
    it 'should return a valid JSON result set.' do
      pending 'Need to setup valid Mixpanel test account.'
      data = @api.request(:events, :general, {
        :event    => '["test-event"]',
        :unit     => 'hour',
        :interval =>  24
      })
      data.should == {:some => 'thing'}
    end
  end

  describe '#hash_args' do
    it 'should return a hashed string alpha sorted by key names.' do
      args              = {:c => 'see', :a => 'aye', :d => 'dee', :b => 'bee'}
      args_alpha_sorted = {:a => 'aye', :b => 'bee', :c => 'see', :d => 'dee'}
      @api.hash_args(args).should == @api.hash_args(args_alpha_sorted)
    end
  end

  describe '#mixpanel_uri' do
    it 'should return a properly formatted mixpanel uri as a string' do
      endpoint, meth, params  = [:events, :general, {:c => 'see', :a => 'aye'}]
      @api.mixpanel_uri(endpoint, meth, params).should == 'http://mixpanel.com/api/events/1.0/general?a=aye&c=see'
    end
  end

  describe '#urlencode' do
    it 'should return a string with url encoded values.' do
      params = {:hey => '!@#$%^&*()\/"Ü', :soo => "hëllö?"}
      @api.urlencode(params).should == 'hey=%21%40%23%24%25%5E%26%2A%28%29%5C%2F%22%C3%9C&soo=h%C3%ABll%C3%B6%3F'
    end
  end
end
