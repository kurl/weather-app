require './lib/api/http_client'

module Provider
  class WeatherStack
    def initialize(token:, logger:)
      @base_url = 'http://api.weatherstack.com/'
      @token = token
      @logger = logger
    end

    def run
      client = ::Api::HttpClient.new(base_url)
      response = client.get('/current', query_params)

      format_response(response) unless response.parsed_body[:success] == false
    rescue Api::NetworkError => e
      logger.error("NETWORK ERROR: #{e.message}")
    end

    private

    attr_reader :base_url, :token, :logger

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
