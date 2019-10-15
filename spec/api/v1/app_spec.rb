require 'spec_helper'

RSpec.describe Api::V1::App do
  include Rack::Test::Methods

  def app
    Api::V1::App
  end

  before do
    allow($stdout).to receive(:write)

    stub_request(:get, /.*api.openweathermap.org.*/)
      .to_return(status: 200, body: {}.to_json)

    stub_request(:get, /.*api.weatherstack.com.*/)
      .to_return(status: 200, body: {}.to_json)
  end

  describe 'Testing endpoints' do
    subject { last_response }

    describe '/v1/weather' do
      before { get '/v1/weather' }
      it { is_expected.to be_ok }
    end

    describe '404' do
      before { get '/abc' }
      it { is_expected.to be_not_found }
    end
  end
end
