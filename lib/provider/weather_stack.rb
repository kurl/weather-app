module Provider
  class WeatherStack < Base
    def initialize(token:, logger:)
      @base_url = 'http://api.weatherstack.com/'
      @token = token
      @logger = logger
    end

    def run
      yield_with_errors do
        api_response = client.get('/current', query_params)
        validate_response!(api_response)

        weather_stack = WeatherStackResponse.new(api_response.parsed_body)
        CurrentWeather.new(
          wind_speed: weather_stack.current.wind_speed,
          temperature_degrees: weather_stack.current.temperature
        )
      end
    end

    private

    def query_params
      {
        access_key: token,
        query: 'melbourne'
      }
    end
  end
end
