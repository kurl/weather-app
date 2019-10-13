require 'net/https'
require 'uri'
require 'json'

module Api
  class InvalidCredentials < StandardError; end
  class NetworkError < StandardError; end

  class HttpClient
    NETWORK_ERRORS = [
      EOFError,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EINVAL,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError,
      Timeout::Error,
      SocketError,
    ].freeze
    
    def initialize(base_url)
      @base_url = URI(base_url)
    end

    def get(endpoint, params = {})
      full_url = URI::HTTP.build(
        host: base_url.host,
        path: endpoint,
        query: URI.encode_www_form(params)
      )
      request = Net::HTTP::Get.new(full_url)
      execute(request)
    end

    private

    attr_reader :base_url, :logger, :http_options

    def execute(request)
      response = http.request(request)
      raise Api::InvalidCredentials, response.body if response.code.to_i == 401

      Response.new(response)
    rescue *NETWORK_ERRORS => error
      raise Api::NetworkError, error.message
    end

    def http
      @http ||= Net::HTTP.new(base_url.host)
    end

    class Response
      def initialize(http_response)
        self.http_response = http_response
      end

      def success?
        http_response.is_a?(Net::HTTPSuccess)
      end

      def parsed_body
        JSON.parse(body.to_s, symbolize_names: true)
      end

      def body
        http_response.read_body
      end

      private

      attr_accessor :http_response
    end
  end
end
