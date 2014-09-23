require "spec_helper"

describe Api::V1::LocationsController, :auth_controller do
  let!(:client) { Fabricate(:client) }
  let(:website) { Fabricate(:website) }
  let(:location) { website.owner }

  describe "#show" do
    it "finds location" do
      Location.should_receive(:find).with(location.id.to_s).once
      get :show, id: location.id
    end

    it "renders location as json" do
      get :show, id: location.id
      expect(response.body).to eq LocationSerializer.new(location).to_json
    end

    it "has attributes" do
      get :show, id: location.id
      result = HashWithIndifferentAccess.new(JSON.parse(response.body))
      expected_response = HashWithIndifferentAccess.new(location: {
          id: location.id,
          urn: location.urn,
          name: location.name,
          domain: location.domain,
          corporate: location.corporate,
          single_domain: false,
          website_slug: website.slug,
          website_heroku_url: website.decorate.heroku_url
        } 
      )
      expect(result).to eq(expected_response)
    end

    context "single_domain" do
      let!(:client) { Fabricate(:client, type: "SingleDomainClient") }
      let!(:heroku_url) { "my.app.name" }

      before do
        LocationSerializer.any_instance.stub(:website_heroku_url).and_return(heroku_url)
      end  
      #let!(:client) { Fabricate(:client, type: "SingleDomainClient") }
      
      # let(:website) { Fabricate(:website) }
      # let(:location) { website.owner }
       # before do
      #   Client.stub_chain(:first, :type).and_return("SingleDomainClient")
      # end  

      it "has attributes" do
        get :show, id: location.id
        result = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected_response = HashWithIndifferentAccess.new(location: {
            id: location.id,
            urn: location.urn,
            name: location.name,
            domain: location.domain,
            corporate: location.corporate,
            single_domain: true,
            website_slug: website.slug,
            website_heroku_url: heroku_url
          } 
        )
        expect(result).to eq(expected_response)
      end
    end  
  end
end
