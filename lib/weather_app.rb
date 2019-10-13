require './lib/provider/weather_stack'

class WeatherApp
  BUFFER = 3

  def initialize(config:, city:)
    @config = config
    @city = city
    @now = Time.now
  end

  def run
    weather_stack.run
  end

  private

  attr_reader :config

  def weather_stack
    Provider::WeatherStack.new(token: config[:weather_stack], city: 'Melbourne')
  end
end
