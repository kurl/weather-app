require 'sinatra'
require './lib/weather_app'

module Api
  class Base < Sinatra::Base
    set :bind, '0.0.0.0'
    set :port, 8080
    set :logging, true
    before { content_type :json }

    def initialize
      super
      @config = load_config
      @weather_app = WeatherApp.new(config: config)
    end

    get '/*' do
      status 404
      { error: 'Not found' }.to_json
    end

    private

    attr_accessor :config, :weather_app

    def load_config
      {
        weather_stack: ENV['WEATHER_STACK_TOKEN'],
        open_weather: ENV['OPEN_WEATHER_TOKEN']
      }
    end
  end
end
