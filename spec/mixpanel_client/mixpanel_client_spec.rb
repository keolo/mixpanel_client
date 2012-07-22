require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mixpanel::Client do
  before :all do
    @client = Mixpanel::Client.new('api_key' => 'test_key', 'api_secret' => 'test_secret')
    @uri = Regexp.escape(Mixpanel::Client::BASE_URI)
  end

  context 'when initializing a new Mixpanel::Client' do
    it 'should not raise an exception if a hash is given' do
      Mixpanel::Client.new('api_key' => 'test_key', 'api_secret' => 'test_secret').should_not raise_error(ArgumentError)
    end
  end

  context 'when making an invalid request' do
    it 'should return an argument error "Wrong number of arguments" if using the deprecated usage' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/).to_return(:body => '{"legend_size": 0, "data": {"series": [], "values": {}}}')

      data = lambda{@client.request(nil, :events, {
        :event    => '["test-event"]',
        :unit     => 'hour',
        :interval =>  24
      })}
      data.should raise_error(ArgumentError)
    end
  end

  context 'when making a valid request' do
    it 'should work without an endpoint' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/).to_return(:body => '{"legend_size": 0, "data": {"series": [], "values": {}}}')

      # No endpoint
      data = @client.request do
        resource 'events'
        event    '["test-event"]'
        unit     'hour'
        interval  24
      end
      data.should == {"data"=>{"series"=>[], "values"=>{}}, "legend_size"=>0}
    end

    it 'should work with an endpoint, method, and type' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/).to_return(:body => '{"events": [], "type": "general"}')

      # With endpoint
      data = @client.request do
        resource 'events/top'
        type     'general'
      end
      data.should == {"events"=>[], "type"=>"general"}
    end

    it 'should create getter methods for given options' do
      @client.resource.should == 'events/top'
      @client.type.should     == 'general'
    end

    it 'should create setter methods for given options' do
      @client.resource 'hi'
      @client.resource.should == 'hi'

      @client.type 'ok'
      @client.type.should == 'ok'
    end
  end

  describe '#hash_args' do
    it 'should return a hashed string alpha sorted by key names.' do
      args              = {:c => 'see', :a => 'ey', :d => 'dee', :b => 'bee'}
      args_alpha_sorted = {:a => 'ey', :b => 'bee', :c => 'see', :d => 'dee'}
      Mixpanel::Client::Utils.generate_signature(args, @client.api_secret).should == Mixpanel::Client::Utils.generate_signature(args_alpha_sorted, @client.api_secret)
    end
  end

  describe '#to_hash' do
    it 'should return a ruby hash given json as a string' do
      Mixpanel::Client::Utils.to_hash('{"a" : "ey", "b" : "bee"}', @client.format).should == {'a' => 'ey', 'b' => 'bee'}
    end
  end

  context 'when resetting options for each request' do
    it 'should reset options before each request' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/).to_return(:body => '{"events": [], "type": "general"}')

      @client.request do
        # This is not a real request. It just lists all possible options.
        resource       'events'
        event          '["test-event"]'
        funnel_id      'down-the-rabbit-hole'
        name           'ricky-bobby'
        type           'A'
        unit           'hour'
        interval       24
        length         1
        limit          5
        format         'csv'
        bucket         'list'
        values         '["tiger", "blood"]'
				timezone	     '-8'
        from_date      '2011-08-11'
        to_date        '2011-08-12'
        on             'properties["product_id"]'
        where          '1 in properties["product_id"]'
        buckets        '5'
        events         [{"event" => "page:view"}, {"event" => "button:click"}].to_json
        retention_type 'abc'
        interval_count 'def'
      end

      Mixpanel::Client::OPTIONS.each do |option|
        @client.send(option).should_not be_nil, "#{option} option was nil"
      end

      @client.request do
        resource 'events/properties/top'
      end

      (Mixpanel::Client::OPTIONS - [:resource]).each do |option|
        @client.send(option).should be_nil
      end
    end
  end
end
