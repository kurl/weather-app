require 'spec_helper'

describe Provider::WeatherStack do
  let(:token) { 'token' }
  let(:logger) { double(Logger, error: true) }
  let(:weather_stack) { described_class.new(token: token, logger: logger) }
  subject { weather_stack }

  context '#run - Getting weather in Melbourne' do
    subject { weather_stack.run }

    let(:base_url) { 'http://api.weatherstack.com/' }
    let(:full_url) do
      "#{base_url}current?access_key=#{token}&query=melbourne"
    end
    let(:api_response) do
      {
        current: {
          temperature: 22,
          wind_speed: 31
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
