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
      format_response(response)
    end

    private

    attr_reader :base_url, :token, :city

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
