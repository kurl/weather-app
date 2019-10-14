module Provider
  class InvalidResponse < StandardError; end
  class Base
    def initialize(token:, logger:)
      @token = token
      @logger = logger
    end

    private

    attr_reader :base_url, :token
    attr_accessor :logger

    def yield_with_errors
      # logger.info "Fetching: #{base_url}"
      yield
    rescue Api::NetworkError => e
      logger.error("Network Error: #{e.message}")
    rescue Api::InvalidCredentials => e
      logger.error("Invalid Credentials: #{e.message}")
    rescue InvalidResponse => e
      logger.error("Invalid Reposne: #{e.message}")
    rescue Dry::Struct::Error => e
      logger.error("Bad data: #{e.message}")
    end

    def client
      Api::HttpClient.new(base_url)
    end

    def validate_response!(response)
      raise InvalidResponse, response.body unless response.success?

      success = response.parsed_body[:success]
      raise InvalidResponse, response.body if success == false
    end
  end
end
