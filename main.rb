require 'sinatra'
require './lib/weather_app'

config = {
  weather_stack: ENV['WEATHER_STACK_TOKEN'],
  open_weather: ENV['OPEN_WEATHER_TOKEN']
}

weather_app = WeatherApp.new(config: config)

get '/v1/weather' do
  content_type :json
  weather_app.run
end
