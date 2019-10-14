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
      current_weather = response.parsed_body[:current]
      {
        wind_speed: current_weather[:wind_speed],
        temperature_degrees: current_weather[:temperature]
      }
    end

    def query_params
      {
        access_key: token,
        query: 'melbourne'
      }
    end
  end
end
