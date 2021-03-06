require 'spec_helper'

describe WhizClient::Geo do

  include RequestHelper
  context 'When APP_KEY is defined' do

    before(:each) do
      stub_const('WhizClient::Client::GEO_API_URL', 'https://example.com/')
      stub_const('WhizClient::Client::APP_KEY', 'xxxxxxxxxxx')
    end

    context '.time_zones' do
      it 'returns an array' do
        fake_response = '{"ResponseCode":0,"ResponseMessage":"OK","ResponseDateTime":"11/7/2014 9:04:32 AM GMT","Data":[ { "_TimeZone": "Dateline Standard Time" }, { "_TimeZone": "UTC-11" }, { "_TimeZone": "Hawaiian Standard Time" }, { "_TimeZone": "Alaskan Standard Time" } ]}'

        stub_request(:get, 'https://example.com/time-zones?AppKey=xxxxxxxxxxx').
           with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => valid_response(:time_zones), :headers => {})

        expect(described_class.list_all_time_zones).to be_a_kind_of Array
      end
    end

    context '.current_time_of_timezone' do
      it 'returns a String' do
        fake_response = '{"ResponseCode":0,"ResponseMessage":"OK","ResponseDateTime":"11/7/2014 9:12:16 AM GMT","Data":"11/7/2014 2:42:16 PM"}'

        stub_request(:get, "https://example.com/current-time-of-timezone?AppKey=xxxxxxxxxxx&zid=Pacific%20Standard%20Time").
           with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => fake_response, :headers => {})

        expect(described_class.find_current_time_by_timezone('Pacific Standard Time')).to be_a_kind_of String
      end
    end
  end

  context 'When APP_KEY is uninitialized' do
    it 'raise exception' do
      expect{ described_class.list_all_time_zones }.to raise_error WhizClient::WhizResponseError
    end
  end

  context 'When method missing' do
    it 'raise exception' do
      expect{ described_class.a_undefined_method }.to raise_error WhizClient::WhizResponseError
    end
  end
end
