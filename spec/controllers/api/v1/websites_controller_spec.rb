require "spec_helper"

describe Api::V1::WebsitesController, :auth_controller do
  let!(:client) { Fabricate(:client) }
  let(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }

  describe "#index" do
    before do
      WebsiteSerializer.new(website)
    end

    it "renders websites as json" do
      get :index
      expect(response.status).to eq 200
      skip("response.body JSON equals Website.all (after ran through the serializer and as JSON)")
    end
  end

  describe "#show" do
    it "finds website" do
      Website.should_receive(:find).with(website.id.to_s).once
      get :show, id: website.id
    end

    it "renders website as json" do
      get :show, id: website.id
      expect(response.body).to eq WebsiteSerializer.new(website).to_json
    end
  end
end
