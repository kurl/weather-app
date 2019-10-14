module Provider
  class OpenWeather < Base
    def initialize(token:, logger:)
      super
      @base_url = 'http://api.openweathermap.org/'
    end

    def run
      yield_with_errors do
        api_response = client.get('/data/2.5/weather', query_params)
        validate_response!(api_response)

        open_weather = OpenWeatherResponse.new(api_response.parsed_body)
        CurrentWeather.new(
          wind_speed: mps_to_kmh(open_weather.wind.speed),
          temperature_degrees: open_weather.main.temp
        )
      end
    end

    private

    def mps_to_kmh(speed)
      (speed.to_f / 1000 * 3600).round
    end

    def query_params
      {
        q: 'melbourne',
        appid: token,
        units: 'metric'
      }
    end
  end
end
