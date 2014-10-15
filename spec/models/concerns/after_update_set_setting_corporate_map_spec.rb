require "spec_helper"

shared_examples_for AfterUpdateSetSettingCorporateMap do
  let(:described_instance) { described_class.new }

  describe ".after_create" do
    it "calls #update_corporate_map_settings" do
      described_instance.should_receive(:update_corporate_map_settings)
      described_instance.save(validate: false)
    end
  end

  describe ".after_update" do
    before { described_instance.save(validate: false) }

    context "state changed" do
      it "calls #update_corporate_map_settings" do
        described_instance.should_receive(:update_corporate_map_settings)
        described_instance.update_attribute(:state, "new state")
      end
    end

    context "status changed" do
      it "calls #update_corporate_map_settings" do
        described_instance.should_receive(:update_corporate_map_settings)
        described_instance.update_attribute(:status, "Suspended")
      end
    end

    context "city changed" do
      it "does not call #update_corporate_map_settings" do
        described_instance.should_not_receive(:update_corporate_map_settings)
        described_instance.update_attribute(:city, "new city")
      end
    end

    context "state did not change" do
      it "does not call #update_corporate_map_settings" do
        described_instance.should_not_receive(:update_corporate_map_settings)
        described_instance.update_attribute(:neighborhood, "new neighborhood")
      end
    end
  end
end

describe Location do
  it_behaves_like AfterUpdateSetSettingCorporateMap
end

