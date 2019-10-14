require 'spec_helper'
require 'byebug'

describe WeatherApp do
  let(:city) { 'Melbourne' }
  let(:config) do
    {
      weather_stack: 'TOKEN',
      open_weather_map: 'TOKEN'
    }
  end
  let(:weather_app) { described_class.new(config: config, city: city) }
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
    before do
      allow(Provider::WeatherStack)
        .to receive(:new)
        .with(token: 'TOKEN', city: city)
        .and_return(weather_stack)
    end

    subject { weather_app.run }

    it { is_expected.to eq current_weather }

    describe 'Buffer' do
      it 'prevents hitting weather provider multiple times' do
        weather_app.run
        weather_app.run

        expect(weather_stack).to have_received(:run).once
      end
    end
  end
end
