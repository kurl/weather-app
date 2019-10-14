module Provider
  class WeatherStack < Base
    def initialize(token:, logger:)
      @base_url = 'http://api.weatherstack.com/'
      @token = token
      @logger = logger
    end

    private

    def endpoint
      '/current'
    end

    def format_response(response)
      json_response = WeatherStackResponse.new(response.parsed_body)
      CurrentWeather.new(
        wind_speed: json_response.current.wind_speed,
        temperature_degrees: json_response.current.temperature
      )
    end

    def query_params
      {
        access_key: token,
        query: 'melbourne'
      }
    end
  end
end
