require './lib/api/http_client'

module Provider
  class Base
    def initialize(token:, logger:)
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

    attr_reader :base_url, :token
    attr_accessor :logger

    def yield_with_errors
      yield
    rescue Api::NetworkError => e
      logger.error("NETWORK ERROR: #{e.message}")
    end

    def client
      Api::HttpClient.new(base_url)
    end
  end
end
