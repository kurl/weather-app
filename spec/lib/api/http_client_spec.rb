require 'spec_helper'

RSpec.describe Api::HttpClient do
  let(:base_url) { 'http://weather.com' }
  let(:http_client) { described_class.new(base_url) }
  let(:token) { '12345' }
  let(:city) { 'Melbourne' }
  let(:response) { { hello: 'world' }.to_json }

  describe 'get' do
    let(:endpoint) { '/current' }
    let(:uri) { URI.join(base_url, endpoint) }
    let(:full_url) { "#{base_url}#{endpoint}?token=#{token}&city=#{city}" }
    let(:params) { { token: token, city: city } }

    subject { http_client.get(endpoint, params) }
    before do
      stub_request(:get, full_url).to_return(status: 200, body: response)
    end

    it { expect { subject }.not_to raise_error }
    it { is_expected.to be_success }
    it { expect(subject.parsed_body).to eq(hello: 'world') }
  end
end
