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
    retrieve_weather(weather_stack_client) if buffer_expired?
    retrieve_weather(open_weather_client)  if buffer_expired?

    current_weather.to_hash.to_json
  end

  private

  attr_reader :config
  attr_accessor :current_weather, :last_call, :logger

  def retrieve_weather(provider)
    result = provider.run
    return unless result.is_a?(Provider::CurrentWeather)

    self.current_weather = result
    self.last_call = Time.now
  end

  def weather_stack_client
    Provider::WeatherStack.new(
      token: config[:weather_stack],
      logger: logger
    )
  end

  def open_weather_client
    Provider::OpenWeather.new(
      token: config[:open_weather],
      logger: logger
    )
  end

  def buffer_expired?
    last_call + BUFFER < Time.now
  end
end
