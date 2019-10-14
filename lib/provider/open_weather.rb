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
      weather = response.parsed_body
      {
        wind_speed: mps_to_kmh(weather[:wind][:speed]),
        temperature_degrees: weather[:main][:temp]
      }
    end

    def mps_to_kmh(speed)
      (speed / 1000 * 3600).round(2)
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
