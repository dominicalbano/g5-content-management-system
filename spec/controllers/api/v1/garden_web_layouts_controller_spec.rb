require "spec_helper"

describe Api::V1::GardenWebLayoutsController, :auth_controller, vcr: VCR_OPTIONS do
  describe "#index" do
    it "finds all garden web layouts" do
      GardenWebLayout.should_receive(:all).once
      get :index
    end
  end

  describe "#update" do
    let(:garden_web_layout) { Fabricate(:garden_web_layout) }

    before(:each) do
      allow(GardenWebLayout).to receive(:find).and_return(garden_web_layout)
    end

    it "queues deploy with async deploy" do
      allow(garden_web_layout).to receive(:async_deploy)
      post :update
    end
  end
end
