module Provider
  class WeatherStack < Base
    def initialize(token:, logger:)
      @base_url = 'http://api.weatherstack.com/'
      @token = token
      @logger = logger
    end

    def run
      yield_with_errors do
        response = client.get(endpoint, query_params)
        format_response(response)
      end
    end

    private

    def endpoint
      '/current'
    end

    def format_response(response)
      if !response.success? || response.parsed_body[:success] == false
        raise InvalidResponse, response.body
      end

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
