require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mixpanel::Client do
  before :all do
    @client = Mixpanel::Client.new(:api_key => 'test_key', :api_secret => 'test_secret')
    @uri = Regexp.escape(Mixpanel::Client::BASE_URI)
  end

  context 'when initializing a new Mixpanel::Client' do
    it 'should not raise an exception if a hash is given' do
      Mixpanel::Client.new('api_key' => 'test_key', 'api_secret' => 'test_secret').should_not raise_error(ArgumentError)
    end

    it 'should set a parallel option as false by default' do
      Mixpanel::Client.new(:api_key => 'test_key', :api_secret => 'test_secret').parallel.should == false
    end

    it 'should be able to set a parallel option when passed' do
      Mixpanel::Client.new(:api_key => 'test_key', :api_secret => 'test_secret', :parallel => true).parallel.should == true
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
      data = @client.request('events', {
        :event    => '["test-event"]',
        :unit     => 'hour',
        :interval => 24
      })
      data.should == {"data"=>{"series"=>[], "values"=>{}}, "legend_size"=>0}
    end

    it 'should work with an endpoint, method, and type' do
      # Stub Mixpanel request
      stub_request(:get, /^#{@uri}.*/).to_return(:body => '{"events": [], "type": "general"}')

      # With endpoint
      data = @client.request('events/top', {
        :type => 'general'
      })
      data.should == {"events"=>[], "type"=>"general"}
    end

    context "with parallel option enabled" do
      before :all do
        @parallel_client = Mixpanel::Client.new(:api_key => 'test_key', :api_secret => 'test_secret', :parallel => true)
      end

      it "should return Typhoeus::Request" do
        # Stub Mixpanel request
        stub_request(:get, /^#{@uri}.*/).to_return(:body => '{"legend_size": 0, "data": {"series": [], "values": {}}}')

        # No endpoint
        data = @parallel_client.request('events', {
          :event    => '["test-event"]',
          :unit     => 'hour',
          :interval => 24
        })
        data.should be_a Typhoeus::Request
      end

      describe '#hydra' do
        it 'should return a Typhoeus::Hydra object' do     
          @parallel_client.hydra.should be_a Typhoeus::Hydra  
        end 
      end

      describe '#run_parallel_requests' do
        it 'should run queued requests' do
          # Stub Mixpanel request
          stub_request(:any, /^#{@uri}.*/).to_return(:body => '{"legend_size": 1, "data": {"series": ["2010-05-29","2010-05-30","2010-05-31"], 
                                                                                         "values": {
                                                                                            "account-page": {"2010-05-30": 1},
                                                                                            "splash features": {"2010-05-29": 6,
                                                                                                                "2010-05-30": 4,
                                                                                                                "2010-05-31": 5
                                                                                                               }
                                                                                         }
                                                                                        }
                                                             }')


          stub_request(:any, /^#{@uri}.*secondevent.*/).to_return(:body => '{"legend_size": 2, "data": {"series": ["2010-05-29","2010-05-30","2010-05-31"], 
                                                                                         "values": {
                                                                                            "account-page": {"2010-05-30": 2},
                                                                                            "splash features": {"2010-05-29": 8,
                                                                                                                "2010-05-30": 6,
                                                                                                                "2010-05-31": 7
                                                                                                               }
                                                                                         }
                                                                                        }
                                                             }')

          first_request = @parallel_client.request('events', {
            :event    => '["firstevent"]',
            :unit     => 'day'
          })


          second_request = @parallel_client.request('events', {
            :event    => '["secondevent"]',
            :unit     => 'day'
          })

          @parallel_client.run_parallel_requests

          first_request.response.handled_response.should == {"data"=>{"series"=>["2010-05-29", "2010-05-30", "2010-05-31"], "values"=>{"splash features"=>{"2010-05-29"=>6, "2010-05-30"=>4, "2010-05-31"=>5}, "account-page"=>{"2010-05-30"=>1}}}, "legend_size"=>1}

          second_request.response.handled_response.should == {"data"=>{"series"=>["2010-05-29", "2010-05-30", "2010-05-31"], "values"=>{"splash features"=>{"2010-05-29"=>8, "2010-05-30"=>6, "2010-05-31"=>7}, "account-page"=>{"2010-05-30"=>2}}}, "legend_size"=>2}
        end
      end
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
      Mixpanel::Client::Utils.to_hash('{"a" : "ey", "b" : "bee"}', :json).should == {'a' => 'ey', 'b' => 'bee'}
    end
  end

end
