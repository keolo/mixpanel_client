require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

WebMock.allow_net_connect!

describe 'External calls to mixpanel' do
  before :all do
    config = YAML.load_file(File.dirname(__FILE__) + '/../../config/mixpanel.yml')['mixpanel']
    config.should_not be_nil
    @client = Mixpanel::Client.new(config)
  end

  context 'when requesting event properties' do
    it 'should raise an error for bad requests' do
      data = lambda do
        @client.request('properties', {})
      end
      data.should raise_error(Mixpanel::HTTPError)
    end

    it 'should return events' do
      data = @client.request('events/properties',
                             event: '["test-event"]',
                             name: 'hello',
                             values: '["uno", "dos"]',
                             type: 'general',
                             unit: 'hour',
                             interval: 24,
                             limit: 5,
                             bucket: 'kicked'
      )
      data.should_not be_a Exception
    end
  end
end
