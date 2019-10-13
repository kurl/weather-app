require 'spec_helper'

describe Provider::WeatherStack do
  let(:token) { 'token' }
  let(:city) { 'Melbourne' }
  let(:weather_stack) { described_class.new(token: token, city: city) }
  subject { weather_stack }

  context '#run - Getting weather in Melbourne' do
    let(:full_url) { "http://api.weatherstack.com/current?access_key=#{token}&query=#{city}" }
    let(:api_response) do
      {
        current: {
          temperature: 22,
          wind_speed: 31,
        }
      }.to_json
    end
    let(:expected_response) do
      {
        wind_speed: 31,
        temperature_degrees: 22
      }
    end

    before do
      stub_request(:get, full_url)
        .to_return(status: 200, body: api_response, headers: {})
    end

    subject { weather_stack.run }

    it { is_expected.to eq expected_response }
  end
end
