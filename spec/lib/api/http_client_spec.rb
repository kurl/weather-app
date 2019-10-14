require 'spec_helper'

RSpec.describe Api::HttpClient do
  let(:base_url) { 'http://weather.com' }
  let(:logger) { double(Logger, info: true) }
  let(:http_client) { described_class.new(base_url, logger: logger) }
  let(:token) { '12345' }
  let(:city) { 'Melbourne' }
  let(:response) { { hello: 'world' }.to_json }

  describe 'get' do
    let(:endpoint) { '/current' }
    let(:uri) { URI.join(base_url, endpoint) }
    let(:full_url) { "#{base_url}#{endpoint}?token=#{token}&city=#{city}" }
    let(:params) { { token: token, city: city } }

    subject { http_client.get(endpoint, params) }

    context 'Sucessful response' do
      before do
        stub_request(:get, full_url).to_return(status: 200, body: response)
      end

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_success }
      it { expect(subject.parsed_body).to eq(hello: 'world') }
    end

    context 'Errors' do
      it 'raises an error for Invalid credentials' do
        stub_request(:get, full_url).to_return(status: 401, body: response)

        expect { subject }.to raise_error(Api::InvalidCredentials)
      end

      it 'raises generic error for network error' do
        stub_request(:get, full_url).to_timeout

        expect { subject }.to raise_error(Api::NetworkError)
      end

      context 'does not raise for non successful response' do
        let(:error) { { error: '500' } }
        before do
          stub_request(:get, full_url)
            .to_return(status: 500, body: error.to_json)
        end

        it { expect { subject }.not_to raise_error }
        it { is_expected.not_to be_success }
        it { expect(subject.parsed_body).to eq(error) }
      end
    end
  end
end
