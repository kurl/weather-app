require './lib/api/http_client'

module Provider
  class WeatherStack
    def initialize(token:, city:)
      @base_url = 'http://api.weatherstack.com/'
      @token = token
      @city = city
    end

    def run
      client = ::Api::HttpClient.new(base_url)
      response = client.get('/current', query_params)
      current_weather(response)
    end

    private

    attr_reader :base_url, :token, :city

    def current_weather(response)
      current_weather = response.parsed_body[:current]
      {
        wind_speed: current_weather[:wind_speed],
        temperature_degrees: current_weather[:temperature]
      }
    end

    def query_params
      {
        access_key: token,
        query: city
      }
    end
  end
end
