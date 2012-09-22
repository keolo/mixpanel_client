require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

WebMock.allow_net_connect!

describe 'External calls to mixpanel' do
  before :all do
    config = YAML.load_file(File.dirname(__FILE__) + '/../../config/mixpanel.yml')['mixpanel']
    config.should_not be_nil
    @client = Mixpanel::Client.new(config)
  end

  context 'when requesting events' do
    it 'should raise an error for bad requests' do
      data = lambda {
        @client.request('events', {})
      }
      data.should raise_error(Mixpanel::HTTPError)
    end

    it 'should return events' do
      data = @client.request('events', {
        :event    => '["test-event"]',
        :type     => 'general',
        :unit     => 'hour',
        :interval =>  24
      })
      data.should_not be_a Exception
    end

    it 'should return events in csv format' do
      data = @client.request('events', {
        :event    => '["test-event"]',
        :type     => 'general',
        :unit     => 'hour',
        :interval =>  24,
        :format   => 'csv'
      })
      data.should_not be_a Exception
    end

    it 'should return events with optional bucket' do
      data = @client.request('events', {
        :event    => '["test-event"]',
        :type     => 'general',
        :unit     => 'hour',
        :interval =>  24,
        :bucket   => 'test'
      })
      data.should_not be_a Exception
    end

    it 'should return top events' do
      data = @client.request('events/top', {
        :type     => 'general',
        :limit    => 10
      })
      data.should_not be_a Exception
    end

    it 'should return names' do
      data = @client.request('events/names', {
        :type     => 'general',
        :unit     => 'hour',
        :interval =>  24,
        :limit    => 10
      })
      data.should_not be_a Exception
    end

    it 'should return retention' do
      pending 'Retention now has its own endpoint.'
      data = @client.request('events/retention', {
        :event    => '["test-event"]',
        :type     => 'general',
        :unit     => 'hour',
        :interval =>  24
      })
      data.should_not be_a Exception
    end

    it 'should return retention in csv format' do
      pending 'Retention now has its own endpoint.'
      data = @client.request('events/retention', {
        :event    => '["test-event"]',
        :type     => 'general',
        :unit     => 'hour',
        :interval =>  24,
        :format   => 'csv'
      })
      data.should_not be_a Exception
    end
  end
end
