require 'logger'
require './lib/provider/weather_stack'
require './lib/provider/open_weather'

class WeatherApp
  BUFFER = 3

  def initialize(config:)
    @config = config
    @last_call = Time.now - BUFFER - 1 # expired buffer
    @current_weather = {}
    @logger = Logger.new(STDOUT)
  end

  def run
    fetch_weather_stack if buffer_expired?
    fetch_open_weather if buffer_expired?

    current_weather
  end

  private

  attr_reader :config
  attr_accessor :current_weather, :last_call, :logger

  def fetch_weather_stack
    result = weather_stack.run
    return unless result

    self.current_weather = result
    self.last_call = Time.now
  end

  def weather_stack
    Provider::WeatherStack.new(
      token: config[:weather_stack],
      logger: logger
    )
  end

  def fetch_open_weather
    self.current_weather = open_weather_data
    self.last_call = Time.now
  end

  def open_weather_data
    Provider::OpenWeather.new(token: config[:open_weather]).run
  end

  def buffer_expired?
    last_call + BUFFER < Time.now
  end
end
