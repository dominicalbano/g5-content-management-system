require "spec_helper"

shared_examples_for AfterUpdateSetPathSettings do
  let(:described_instance) { described_class.new }

  describe ".after_update" do
    before { described_instance.save(validate: false) }

    context "state changed" do
      it "calls #update_cta_settings" do
        described_instance.should_receive(:update_cta_settings)
        described_instance.update_attribute(:state, "new state")
      end

      it "calls #update_nav_settings" do
        described_instance.should_receive(:update_nav_settings)
        described_instance.update_attribute(:state, "new state")
      end
    end

    context "city changed" do
      it "calls #update_cta_settings" do
        described_instance.should_receive(:update_cta_settings)
        described_instance.update_attribute(:city, "new city")
      end
    end

    context "state did not change" do
      it "does not call #update_cta_settings" do
        described_instance.should_not_receive(:update_cta_settings)
        described_instance.update_attribute(:neighborhood, "new neighborhood")
      end
    end
  end
end

describe Location do
  it_behaves_like AfterUpdateSetPathSettings
end
