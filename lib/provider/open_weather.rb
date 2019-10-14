require './lib/api/http_client'

module Provider
  class OpenWeather
    def initialize(token:)
      @base_url = 'http://api.openweathermap.org/'
      @token = token
    end

    def run
      client = ::Api::HttpClient.new(base_url)
      response = client.get('/data/2.5/weather', query_params)
      current_weather(response)
    end

    private

    attr_reader :base_url, :token, :city

    def current_weather(response)
      weather = response.parsed_body
      {
        wind_speed: weather[:wind][:speed],
        temperature_degrees: weather[:main][:temp]
      }
    end

    def query_params
      {
        q: 'melbourne,AU',
        appid: token,
        units: 'metric'
      }
    end
  end
end
