require 'net/https'
require 'uri'
require 'json'

module Api
  class HttpClient
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
      Response.new(response)
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
