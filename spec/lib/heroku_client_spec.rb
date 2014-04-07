require 'spec_helper'

describe HerokuClient do
  let(:heroku_client) { HerokuClient.new(app, api_key) }
  let(:response) { double(body: '[{"foo":"bar"}]') }
  let(:app) { "chucknorris" }
  let(:api_key) { "12345" }

  describe "#releases" do
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

    it { should eq([{ "foo" => "bar" }]) }
  end

  describe "#rollback" do
    let(:id) { "123" }

    before { HTTParty.stub(:post) }

    subject { heroku_client.rollback(id) }

    it "calls the Heroku api resource with the appropriate headers and body" do
      HTTParty.should_receive(:post).with(
        "https://api.heroku.com/apps/#{app}/releases",
        { body: { release: id },
          headers: { "Content-Type" => "application/json",
                     "Accept" => "application/vnd.heroku+json; version=3",
                     "Authorization" => Base64.encode64(":#{api_key}") } }
      )
      subject
    end
  end
end
