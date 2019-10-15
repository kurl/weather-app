require './api/base'

module Api
  module V1
    class App < Api::Base
      get '/v1/weather' do
        weather_app.run
      end
    end
  end
end
