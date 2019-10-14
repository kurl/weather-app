require 'logger'
require 'dry-types'
require 'dry-struct'

require './lib/api/http_client'
require './lib/provider/types'
require './lib/provider/base'
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

    current_weather.to_hash.to_json
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
    result = open_weather.run
    return unless result

    self.current_weather = result
    self.last_call = Time.now
  end

  def open_weather
    Provider::OpenWeather.new(
      token: config[:open_weather],
      logger: logger
    )
  end

  def buffer_expired?
    last_call + BUFFER < Time.now
  end
end
