require 'spec_helper'

describe Provider::OpenWeather do
  let(:token) { 'token' }
  let(:weather_stack) { described_class.new(token: token, logger: logger) }
  let(:logger) { double(Logger, error: true) }

  subject { open_weather }

  context '#run - Getting weather in Melbourne' do
    let(:base_url) { 'http://api.openweathermap.org/' }
    let(:full_url) do
      "#{base_url}data/2.5/weather?q=melbourne&appid=#{token}&units=metric"
    end
    let(:api_response) do
      {
        main: { temp: 15 },
        wind: { speed: 7.7 }
      }.to_json
    end
    let(:expected_response) do
      {
        wind_speed: 27.72,
        temperature_degrees: 15
      }
    end

    before do
      stub_request(:get, full_url)
        .to_return(status: 200, body: api_response, headers: {})
    end

    subject { weather_stack.run }

    it { is_expected.to eq expected_response }

    context 'NetworkError' do
      before { stub_request(:get, full_url).to_timeout }
      let(:error_msg) { 'NETWORK ERROR: execution expired' }

      it 'logs the error and returns nil' do
        expect(logger).to receive(:error).with(error_msg)
        expect { subject }.not_to raise_error
      end
    end
  end
end
