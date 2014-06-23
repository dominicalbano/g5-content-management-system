require "spec_helper"

shared_examples_for HasSettingLocationsNavigation do
  let(:described_instance) { described_class.new }

  describe "#update_locations_navigation_setting" do
    before { described_instance.save(validate: false) }
    before { Location.any_instance.stub(:update_locations_navigation_settings) }
    let!(:location) { Fabricate(:location) }
    let!(:setting) { Fabricate(:setting, owner: described_instance, name: "locations_navigation") }

    it "updates settings" do
      expect(setting.value).to be_nil
      described_instance.update_locations_navigation_setting
      expect(setting.reload.value).to_not be_nil
    end
  end
end

describe Website do
  it_behaves_like HasSettingLocationsNavigation
end
