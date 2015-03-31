require "spec_helper"

describe Api::V1::GardenWebThemesController, :auth_controller, vcr: VCR_OPTIONS do
  describe "#index" do
    it "finds all garden web themes" do
      GardenWebTheme.should_receive(:all).once
      get :index
    end
  end
    
  describe "#update" do
    let(:garden_web_theme) { Fabricate(:garden_web_theme) }

    before(:each) do
      allow(GardenWebTheme).to receive(:find).and_return(garden_web_theme)
    end

    it "queues deploy with async deploy" do
      allow(garden_web_theme).to receive(:async_deploy)
      post :update
    end
  end
end
