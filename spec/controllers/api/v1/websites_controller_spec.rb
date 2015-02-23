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
      get :show, id: website.slug
      expect(response.status).to eq 200
    end

    it "renders website as json" do
      get :show, id: website.slug
      expect(response.body).to eq WebsiteSerializer.new(website).to_json
    end
  end

  describe "#update_navigation_settings" do
    let(:website) { Fabricate(:website) }

    before(:each) do
      allow(Website).to receive(:find).and_return(website)
    end
    
    it "updates navigation settings" do
      expect(Resque).to receive(:enqueue)
      post :update_navigation_settings, website_id: 1
      expect(response.body).to eq %Q({"message":"Page order Updated."})
    end
  end

  describe "#deploy" do
    let(:website) { Fabricate(:website) }

    before(:each) do
      allow(Website).to receive(:find).and_return(website)
    end

    it "queues deploy with async deploy" do
      # add test for passing email to async_deploy
      allow(website).to receive(:async_deploy)
      post :deploy, website_id: 1
      expect(response.body).to eq %Q({"message":"Deploying website #{website.name}. This may take few minutes."})
    end
  end
end
