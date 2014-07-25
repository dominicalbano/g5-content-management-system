require "spec_helper"

describe CorporateMapSetting do
  let!(:location_2) { Fabricate(:location, state: "CA", city: "San Francisco") }
  let!(:location_3) { Fabricate(:location, state: "OR") }
  let!(:location_1) { Fabricate(:location, state: "CA", city: "Los Angeles") }

  describe "#populated_states" do
    subject { CorporateMapSetting.new.populated_states }

    it "returns an array of states that have locations" do
      expect(subject).to eq (["CA", "OR"])
    end
  end

  describe "#state_location_counts" do
    subject { CorporateMapSetting.new.state_location_counts }

    it "returns a hash of states and their location counts" do
      expect(subject).to eq ({ "CA" => 2, "OR" => 1 })
    end
  end

  describe "#value" do
    subject { CorporateMapSetting.new.value }

    it { is_expected.to eq({ "populated_states" => ["CA", "OR"],
                             "state_location_counts" => { "CA" => 2, "OR" => 1 } }) }
  end
end
