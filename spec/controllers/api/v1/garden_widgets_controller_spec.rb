require "spec_helper"

describe Api::V1::GardenWidgetsController, :auth_controller, vcr: VCR_OPTIONS do
  describe "#index" do
    it "finds all garden widgets" do
      GardenWidget.should_receive(:all).once
      get :index
    end
  end

  describe "#update" do
    let(:garden_widget) { Fabricate(:garden_widget) }

    before(:each) do
      allow(GardenWidget).to receive(:find).and_return(garden_widget)
    end

    it "queues deploy with async deploy" do
      allow(garden_widget).to receive(:async_deploy)
      post :update
    end
  end
end
