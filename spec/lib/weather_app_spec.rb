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

  context '#run' do
    before do
      allow_any_instance_of(Provider::WeatherStack)
        .to receive(:run)
        .and_return(current_weather)
    end

    subject { weather_app.run }

    it { is_expected.to eq current_weather }
  end
end
