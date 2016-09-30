require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

WebMock.allow_net_connect!

describe 'External calls to mixpanel' do
  before :all do
    config = YAML.load_file(File.join(
                              File.dirname(__FILE__),
                              '..',
                              '..',
                              'config',
                              'mixpanel.yml'
    ))['mixpanel']

    expect(config).to_not be_nil
    @client = Mixpanel::Client.new(config)
  end

  context 'when requesting events' do
    it 'should raise an error for bad requests' do
      data = lambda do
        @client.request('events', {})
      end
      expect(data).to raise_error(Mixpanel::HTTPError)
    end

    it 'should return events' do
      data = @client.request('events',
                             event: '["test-event"]',
                             type: 'general',
                             unit: 'hour',
                             interval: 24)
      expect(data).to_not be_a Exception
    end

    it 'should return events in csv format' do
      data = @client.request('events',
                             event: '["test-event"]',
                             type: 'general',
                             unit: 'hour',
                             interval: 24,
                             format: 'csv')
      expect(data).to_not be_a Exception
    end

    it 'should return events with optional bucket' do
      data = @client.request('events',
                             event: '["test-event"]',
                             type: 'general',
                             unit: 'hour',
                             interval: 24,
                             bucket: 'test')
      expect(data).to_not be_a Exception
    end

    it 'should return top events' do
      data = @client.request('events/top',
                             type: 'general',
                             limit: 10)
      expect(data).to_not be_a Exception
    end

    it 'should return names' do
      data = @client.request('events/names',
                             type: 'general',
                             unit: 'hour',
                             interval: 24,
                             limit: 10)
      expect(data).to_not be_a Exception
    end

    it 'should return retention' do
      pending 'Retention now has its own endpoint.'
      data = @client.request('events/retention',
                             event: '["test-event"]',
                             type: 'general',
                             unit: 'hour',
                             interval: 24)
      expect(data).to_not be_a Exception
    end

    it 'should return retention in csv format' do
      pending 'Retention now has its own endpoint.'
      data = @client.request('events/retention',
                             event: '["test-event"]',
                             type: 'general',
                             unit: 'hour',
                             interval: 24,
                             format: 'csv')
      expect(data).to_not be_a Exception
    end
  end
end
