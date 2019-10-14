module Provider
  class OpenWeather < Base
    def initialize(token:, logger:)
      super
      @base_url = 'http://api.openweathermap.org/'
    end

    private

    def endpoint
      '/data/2.5/weather'
    end

    def format_response(response)
      json_response = OpenWeatherResponse.new(response.parsed_body)
      CurrentWeather.new(
        wind_speed: mps_to_kmh(json_response.wind.speed),
        temperature_degrees: json_response.main.temp
      )
    end

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
