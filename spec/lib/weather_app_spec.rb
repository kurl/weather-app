require 'spec_helper'

describe WeatherApp do
  let(:config) do
    {
      weather_stack: 'TOKEN',
      open_weather: 'TOKEN'
    }
  end
  let(:weather_app) { described_class.new(config: config) }
  let(:current_weather) do
    {
      wind_speed: 30,
      temperature_degrees: 22
    }
  end

  describe '#run' do
    let(:weather_stack) do
      instance_double(Provider::WeatherStack, run: current_weather)
    end
    let(:open_weather) do
      instance_double(Provider::OpenWeather, run: current_weather)
    end
    before do
      allow(Provider::WeatherStack)
        .to receive(:new)
        .with(token: 'TOKEN', logger: an_instance_of(Logger))
        .and_return(weather_stack)

      allow(Provider::OpenWeather)
        .to receive(:new)
        .with(token: 'TOKEN', logger: an_instance_of(Logger))
        .and_return(open_weather)
    end

    subject { weather_app.run }

    it { is_expected.to eq current_weather.to_json }
    it { expect(open_weather).to_not have_received(:run) }

    describe 'Buffer' do
      it 'prevents hitting weather provider multiple times' do
        weather_app.run
        weather_app.run

        expect(weather_stack).to have_received(:run).once
      end

      it 'resumes after buffer expires' do
        weather_app.run
        future_time = Time.now + WeatherApp::BUFFER + 5
        allow(Time).to receive(:now).and_return(future_time)

        weather_app.run
        expect(weather_stack).to have_received(:run).twice
      end
    end

    describe 'Failover' do
      let(:weather_stack) { instance_double(Provider::WeatherStack, run: nil) }

      it 'Hits backup API if weather_stack is down' do
        weather_app.run
        expect(open_weather).to have_received(:run).once
      end

      context 'OpenWeather is down' do
        let(:open_weather) { instance_double(Provider::OpenWeather, run: nil) }
        it { is_expected.to eq('{}') }
      end
    end
  end
end
