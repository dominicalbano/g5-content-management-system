require "spec_helper"

shared_examples_for AfterUpdateSetSettingLocationsNavigation do
  let(:described_instance) { described_class.new }

  describe ".after_create" do
    it "calls #update_locations_navigation_settings" do
      described_instance.should_receive(:update_locations_navigation_settings)
      described_instance.save(validate: false)
    end
  end

  describe ".after_update" do
    before do
      described_instance.save(validate: false)
    end
    context "state changed" do
      it "calls #update_locations_navigation_settings" do
        described_instance.should_receive(:update_locations_navigation_settings)
        described_instance.update_attribute(:state, "new state")
      end
    end
    context "city changed" do
      it "calls #update_locations_navigation_settings" do
        described_instance.should_receive(:update_locations_navigation_settings)
        described_instance.update_attribute(:city, "new city")
      end
    end
    context "name changed" do
      it "calls #update_locations_navigation_settings" do
        described_instance.should_receive(:update_locations_navigation_settings)
        described_instance.update_attribute(:name, "new name")
      end
    end
    context "state, city, and name did not change" do
      it "does not call #update_locations_navigation_settings" do
        described_instance.should_not_receive(:update_locations_navigation_settings)
        described_instance.update_attribute(:neighborhood, "new neighborhood")
      end
    end
  end
end

describe Location do
  it_behaves_like AfterUpdateSetSettingLocationsNavigation
end
