require "spec_helper"

shared_examples_for HasSettingCorporateMap do
  let(:described_instance) { described_class.new }

  describe "#update_corporate_map_setting" do
    before do
      described_instance.save(validate: false)
      Location.any_instance.stub(:update_corporate_map_settings)
    end

    let!(:location) { Fabricate(:location) }
    let!(:setting) { Fabricate(:setting, owner: described_instance, name: "corporate_map") }

    it "updates settings" do
      expect(setting.value).to be_nil
      described_instance.update_corporate_map_setting
      expect(setting.reload.value).to_not be_nil
    end
  end
end

describe Website do
  it_behaves_like HasSettingCorporateMap
end
