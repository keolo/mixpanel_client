require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mixpanel::Client do
  before :all do
    @client = Mixpanel::Client.new(
      api_secret: 'test_secret'
    )

    @uri = Regexp.escape(Mixpanel::Client::BASE_URI)
  end

  context 'when initializing a new Mixpanel::Client' do
    it 'should set a timeout option as nil by default' do
      expect(Mixpanel::Client.new(
        api_secret: 'test_secret'
      ).timeout).to be_nil
    end

    it 'should be able to set a timeout option when passed' do
      expect(Mixpanel::Client.new(
        api_secret: 'test_secret',
        timeout: 3
      ).timeout).to eql(3)
    end
  end

  context 'when making an invalid request' do
    it 'should raise an error when API secret is null' do
      expect do
        Mixpanel::Client.new(
          api_secret: nil
        )
      end.to raise_error(Mixpanel::ConfigurationError)
    end

    it 'should return an argument error "Wrong number of arguments" if using
        the deprecated usage' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/)
        .to_return(
          body: '{"legend_size": 0, "data": {"series": [], "values": {}}}'
        )

      expect {
        @client.request(
          nil,
          :events,
          event: '["test-event"]',
          unit: 'hour',
          interval: 24
        )
      }.to raise_error(ArgumentError)
    end
  end

  context 'when making a valid request' do
    it 'should work without an endpoint' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/)
        .to_return(
          body: '{"legend_size": 0, "data": {"series": [], "values": {}}}'
        )

      # No endpoint
      data = @client.request(
        'events',
        event: '["test-event"]',
        unit: 'hour',
        interval: 24
      )

      expect(data).to eq(
        'data' => {
          'series' => [],
          'values' => {}
        },
        'legend_size' => 0
      )
    end

    it 'should work when it receives an integer response on import' do
      @import_uri = Regexp.escape(Mixpanel::Client::IMPORT_URI)
      # Stub Mixpanel import request to return a realistic response
      stub_request(:get, /^#{@import_uri}.*/).to_return(body: '1')

      data = @client.request(
        'import',
        data: 'base64_encoded_data',
        api_key: 'test_key'
      )

      expect(data).to eq([1])
    end

    it 'should work with an endpoint, method, and type' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/)
        .to_return(
          body: '{"events": [], "type": "general"}'
        )

      # With endpoint
      data = @client.request(
        'events/top',
        type: 'general'
      )

      expect(data).to eq(
        'events' => [],
        'type'   => 'general'
      )
    end

    it 'does not modify the provided options' do
      options = { foo: 'bar' }
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/)
        .to_return(
          body: '{"events": [], "type": "general"}'
        )

      expect do
        @client.request('events/top', options)
      end.to_not change { options }
    end
  end

  describe '#to_hash' do
    it 'should return a ruby hash given json as a string' do
      expect(Mixpanel::Client::Utils.to_hash(
               '{"a" : "ey", "b" : "bee"}',
               :json
      )).to eq(
        'a' => 'ey',
        'b' => 'bee'
      )
    end
  end
end
