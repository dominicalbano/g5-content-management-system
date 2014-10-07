require "spec_helper"

describe Api::V1::LocationsController, :auth_controller do
  let!(:client) { Fabricate(:client) }
  let(:location) { Fabricate(:location) }

  describe "#show" do
    it "finds location" do
      Location.should_receive(:find).with(location.id.to_s).once
      get :show, id: location.id
    end

    it "renders location as json" do
      get :show, id: location.id
      expect(response.body).to eq LocationSerializer.new(location).to_json
    end
  end
end
