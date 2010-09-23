require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

WebMock.allow_net_connect!

describe 'External calls to mixpanel' do
  before :all do
    config = YAML.load_file(File.dirname(__FILE__) + '/../config/mixpanel.yml')
    config.should_not be_nil
    @api = Mixpanel::Client.new(config)
  end

  describe '#request' do
    it 'should return json and convert to a ruby hash' do
      data = @api.request(nil, :events, {
        :event    => '["test-event"]',
        :unit     => 'hour',
        :interval =>  24
      })
      data.should == {"data"=>{"series"=>[], "values"=>{}}, "legend_size"=>0}
    end

    it 'should respond to top events' do
      data = @api.request(:events, :top, {
        :type => 'general',
      })
      data.should == {"events"=>[], "type"=>"general"}
    end
  end
end
