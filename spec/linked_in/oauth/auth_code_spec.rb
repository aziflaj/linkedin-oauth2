require "spec_helper"
require "uri"
require "cgi"

describe "OAuth2 Auth Code" do
  before(:each) do
    LinkedIn.configure do |config|
      config.client_id     = "dummy_client_id"
      config.client_secret = "dummy_client_secret"
    end
  end

  subject { LinkedIn::OAuth2.new }

  def params(key, opts=nil)
    CGI.parse(URI.parse(subject.auth_code_url(opts)).query)[key][0]
  end

  context "When no redirect_uri is given" do
    before(:each) do
      LinkedIn.configure { |config| config.redirect_uri = nil }
    end

    let(:err_msg) {"You must provide a redirect_uri to get your auth_code_uri. Set it in LinkedIn.configure or pass it in as the redirect_uri option. It must exactly match the redirect_uri you set on your application's settings page on LinkedIn's website."}

    it "Throws an error" do
      expect {subject.auth_code_url}.to raise_error(LinkedIn::OAuthError, err_msg)
    end
  end

  context "When an auth code url is requested with no options" do
    let(:redirect_uri) { "http://lvh.me:5000" }
    let(:scope) { "r_fullprofile r_emailaddress r_network" }

    before(:each) do
      LinkedIn.configure do |config|
        config.redirect_uri = redirect_uri
        config.scope = scope
      end
    end

    it "Returns the client id in the uri" do
      expect(params("client_id")).to eq LinkedIn.config.client_id
    end

    it "Includes the configured redirect_uri" do
      expect(params("redirect_uri")).to eq redirect_uri
    end

    it "Includes the configured scope" do
      expect(params("scope")).to eq scope
    end

    it "Includes no state" do
      expect(params("state")).to be_nil
    end
  end

  context "When an auth code url is requested with options" do
    let(:state) { "foobarbaz" }
    let(:scope) { "r_basicprofile rw_nus" }
    let(:redirect_uri) { "https://example.com" }

    let(:opts) do
      {state: state,
       scope: scope,
       redirect_uri: redirect_uri}
    end

    it "Returns the client id in the uri" do
      expect(params("client_id", opts)).to eq LinkedIn.config.client_id
    end

    it "Includes the custom redirect_uri" do
      expect(params("redirect_uri", opts)).to eq redirect_uri
    end

    it "Includes the custom scope" do
      expect(params("scope", opts)).to eq scope
    end

    it "Includes the custom state" do
      expect(params("state", opts)).to eq state
    end
  end

end
