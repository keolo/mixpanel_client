require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

WebMock.allow_net_connect!

describe 'External calls to mixpanel' do
  before :all do
    config = YAML.load_file(File.dirname(__FILE__) + '/../config/mixpanel.yml')
    config.should_not be_nil
    @api = Mixpanel::Client.new(config)
  end

  describe 'Events' do
    it 'should return events' do
      data = @api.request do
        resource 'events'
        event    '["test-event"]'
        type     'general'
        unit     'hour'
        interval  24
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end

    it 'should return events in csv format' do
      data = @api.request do
        resource 'events'
        event    '["test-event"]'
        type     'general'
        unit     'hour'
        interval  24
        format   'csv'
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end

    it 'should return events with optional bucket' do
      pending
      data = @api.request do
        resource 'events'
        event    '["test-event"]'
        type     'general'
        unit     'hour'
        interval  24
        bucket   'test'
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end

    it 'should return top events' do
      data = @api.request do
        resource 'events/top'
        type     'general'
        limit    10
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end

    it 'should return names' do
      data = @api.request do
        resource 'events/names'
        type     'general'
        unit     'hour'
        interval  24
        limit    10
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end

    it 'should return retention' do
      data = @api.request do
        resource 'events/retention'
        event    '["test-event"]'
        type     'general'
        unit     'hour'
        interval  24
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end

    it 'should return retention in csv format' do
      data = @api.request do
        resource 'events/retention'
        event    '["test-event"]'
        type     'general'
        unit     'hour'
        interval  24
        format   'csv'
      end
      data.should_not raise_error(OpenURI::HTTPError)
    end
  end
end
