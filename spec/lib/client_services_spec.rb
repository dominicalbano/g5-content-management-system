require 'spec_helper'

describe ClientServices do
  let(:client_urn) { "g5-c-irrelevant-clientname" }
  let!(:client) { Fabricate(:client, :uid => "http://www.irrelevant.com/#{client_urn}") }
  let!(:location1) { Fabricate(:location) }
  let!(:location2) { Fabricate(:location) }

  before do
    @client_services = ClientServices.new
    @heroku_app_max_length = ClientServices::HEROKU_APP_NAME_MAX_LENGTH
  end

  describe "#client" do
    it "grabs the first client" do
      @client_services.client.should == Client.first
    end
  end

  describe "#client_urn" do
    it "grabs the client_urn" do
      @client_services.client_urn.should == client_urn
    end
  end

  describe "#client_app_name" do
    it "grabs the full client_app_name" do
      @client_services.client_app_name.should == client_urn
    end

    it "grabs the truncated client_app_name" do
      client.destroy
      long_urn_client = Fabricate(:client, :uid => "http://www.irrelevant.com/g5-c-irrelevant-clientname-thiswillbecutoff")
      ClientServices.new.client_app_name.should == "g5-c-irrelevant-clientname-thi"
    end
  end

  describe "#client_url" do
    it "grabs the client_url" do
      @client_services.client_url.should == "http://#{@client_services.client_app_name}.herokuapp.com/"
    end
  end

  describe "#client_location_urns" do
    it "grabs the client_location_urns" do
      @client_services.client_location_urns.should == [location1.urn, location2.urn]
    end
  end

  describe "#client_location_urls" do
    it "grabs the client_location_urls" do
      @client_services.client_location_urls.should =~ [location1.domain, location2.domain]
    end
  end

  describe "services" do
    ClientServices::SERVICES.each do |service|
      describe "#{service}_urn" do
        it "grabs the #{service}_urn" do
          @client_services.send(:"#{service}_urn").should == "g5-#{service}-irrelevant-clientname"
        end
      end

      describe "#{service}_app_name" do
        it "grabs the #{service}_app_name" do
          @client_services.send(:"#{service}_app_name").should == "g5-#{service}-irrelevant-clientname"[0...@heroku_app_max_length]
        end
      end

      describe "#{service}_url" do
        it "grabs the #{service}_url" do
          service_app_name = "g5-#{service}-irrelevant-clientname"[0...@heroku_app_max_length]
          @client_services.send(:"#{service}_url").should == "http://#{service_app_name}.herokuapp.com/"
        end
      end
    end

    describe "service URL" do
      context "by default" do
        subject { @client_services.cls_url }
        it { should eq("http://g5-cls-irrelevant-clientname.herokuapp.com/") }
      end

      context "passed secure: true" do
        subject { @client_services.cls_url(secure: true) }
        it { should eq("https://g5-cls-irrelevant-clientname.herokuapp.com/") }
      end
    end
  end
end
