require 'spec_helper'

describe HerokuClient do
  let(:heroku_client) { HerokuClient.new(app, api_key) }
  let(:app) { "foo" }
  let(:api_key) { "12345" }

  describe "#releases" do
    let(:response) { double(body: '[{"foo":"bar"}]') }

    before { HTTParty.stub(get: response) }

    subject { heroku_client.releases }

    it "calls the Heroku api resource with the appropriate headers" do
      HTTParty.should_receive(:get).with(
        "https://api.heroku.com/apps/#{app}/releases",
        { headers: { "Content-Type" => "application/json",
                     "Accept" => "application/vnd.heroku+json; version=3",
                     "Authorization" => Base64.encode64(":#{api_key}") } }
      )
      subject
    end
  end

  describe "#rollback" do
    let(:id) { "123" }

    before { HTTParty.stub(:post) }

    subject { heroku_client.rollback(id) }

    it "calls the Heroku api resource with the appropriate headers and body" do
      HTTParty.should_receive(:post).with(
        "https://api.heroku.com/apps/#{app}/releases",
        { body: { "release" => id }.to_json,
          headers: { "Content-Type" => "application/json",
                     "Accept" => "application/vnd.heroku+json; version=3",
                     "Authorization" => Base64.encode64(":#{api_key}") } }
      )
      subject
    end
  end

  describe "#set_config" do
    let(:env) { "FOO" }
    let(:value) { "bar-baz" }

    before { HTTParty.stub(:patch) }

    subject { heroku_client.set_config(env, value) }

    it "calls the Heroku api resource with the appropriate headers and body" do
      HTTParty.should_receive(:patch).with(
        "https://api.heroku.com/apps/#{app}/config-vars",
        { body: { env => value }.to_json,
          headers: { "Content-Type" => "application/json",
                     "Accept" => "application/vnd.heroku+json; version=3",
                     "Authorization" => Base64.encode64(":#{api_key}") } }
      )
      subject
    end
  end
end
