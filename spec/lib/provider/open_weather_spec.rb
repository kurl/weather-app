require 'spec_helper'

describe Provider::OpenWeather do
  let(:token) { 'token' }
  let(:open_weather) { described_class.new(token: token, logger: logger) }
  let(:logger) { double(Logger, error: true) }
  let(:base_url) { 'http://api.openweathermap.org/' }
  let(:url) do
    "#{base_url}data/2.5/weather?q=melbourne&appid=#{token}&units=metric"
  end
  let(:api_response) do
    {
      main: { temp: 15 },
      wind: { speed: 7.7 }
    }.to_json
  end
  let(:expected_response) do
    Provider::CurrentWeather.new(
      wind_speed: 28,
      temperature_degrees: 15
    )
  end

  before do
    stub_request(:get, url)
      .to_return(status: 200, body: api_response, headers: {})
  end

  context '#run - Getting weather in Melbourne' do
    subject { open_weather.run }
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

      context 'Bad data' do
        let(:body) { { abc: true }.to_json }
        before { stub_request(:get, url).to_return(status: 200, body: body) }
        it { expect(logger).to receive(:error).with(/Bad data/) }
      end
    end
  end
end
