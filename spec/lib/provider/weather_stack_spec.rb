require 'spec_helper'

describe Provider::WeatherStack do
  let(:token) { 'token' }
  let(:base_url) { 'http://api.weatherstack.com/' }
  let(:url) do
    "#{base_url}current?access_key=#{token}&query=melbourne"
  end
  let(:logger) { double(Logger, error: true) }
  let(:weather_stack) { described_class.new(token: token, logger: logger) }
  let(:api_response) do
    {
      current: {
        temperature: 22,
        wind_speed: 31
      }
    }.to_json
  end
  let(:expected_response) do
    Provider::CurrentWeather.new(
      wind_speed: 31,
      temperature_degrees: 22
    )
  end

  before do
    stub_request(:get, url)
      .to_return(status: 200, body: api_response, headers: {})
  end

  context '#run - Getting weather in Melbourne' do
    subject { weather_stack.run }

    it { is_expected.to eq expected_response }

    context '#run - Getting weather in Melbourne' do
      subject { weather_stack.run }
      it { is_expected.to eq expected_response }

      describe 'Errors' do
        after { expect { subject }.not_to raise_error }

        context 'NetworkError' do
          before { stub_request(:get, url).to_timeout }
          it { expect(logger).to receive(:error).with(/Network Error/) }
        end

        context 'Invalid Credentials' do
          before { stub_request(:get, url).to_return(status: 401) }
          it { expect(logger).to receive(:error).with(/Invalid Credentials/) }
        end

        context 'Invalid Response' do
          before { stub_request(:get, url).to_return(status: 422) }
          it { expect(logger).to receive(:error).with(/Invalid Reposne/) }
        end

        context 'Invalid Response' do
          let(:body) { { success: false }.to_json }
          before { stub_request(:get, url).to_return(status: 200, body: body) }
          it { expect(logger).to receive(:error).with(/Invalid Reposne/) }
        end

        context 'Bad data' do
          let(:body) { { abc: true }.to_json }
          before { stub_request(:get, url).to_return(status: 200, body: body) }
          it { expect(logger).to receive(:error).with(/Bad data/) }
        end
      end
    end
  end
end
