require './lib/provider/weather_stack'
require './lib/provider/open_weather'

class WeatherApp
  BUFFER = 3

  def initialize(config:, city:)
    @config = config
    @city = city
    @last_call = Time.now - BUFFER - 1 # expired buffer
    @current_weather = {}
  end

  def run
    fetch_weather_stack if buffer_expired?

    current_weather
  end

  private

  attr_reader :config, :city
  attr_accessor :current_weather, :last_call

  def fetch_weather_stack
    self.current_weather = weather_stack_data
    self.last_call = Time.now
  end

  def weather_stack_data
    Provider::WeatherStack.new(
      token: config[:weather_stack],
      city: city
    ).run
  end

  def buffer_expired?
    last_call + BUFFER < Time.now
  end
end
