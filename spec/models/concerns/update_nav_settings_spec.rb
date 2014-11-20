require "spec_helper"

shared_examples_for UpdateNavSettings do
  let(:described_instance) { described_class.new(garden_widget: garden_widget) }
  let(:garden_widget) { Fabricate(:garden_widget, name: widget_name) }

  describe ".after_create" do
    context "non navigation based widgets" do
      let(:widget_name) { "HTML" }

      it "does nothing" do
        described_instance.should_not_receive(:update_nav_settings)
        described_instance.save(validate: false)
      end
    end

    context "Navigation widget" do
      let(:widget_name) { "Navigation" }

      it "callls update_nav_settings" do
        described_instance.should_receive(:update_nav_settings)
        described_instance.save(validate: false)
      end
    end

    context "Calls To Action widget" do
      let(:widget_name) { "Calls To Action" }

      it "callls update_nav_settings" do
        described_instance.should_receive(:update_nav_settings)
        described_instance.save(validate: false)
      end
    end
  end

  describe ".after_update" do
    context "non layout based widgets" do
      let(:widget_name) { "HTML" }

      it "does nothing" do
        described_instance.should_not_receive(:update_nav_settings)
        described_instance.save(validate: false)
        described_instance.update(garden_widget: garden_widget)
      end
    end

    context "Column widget" do
      let(:widget_name) { "Column" }

      it "callls update_nav_settings" do
        described_instance.should_receive(:update_nav_settings)
        described_instance.save(validate: false)
        described_instance.update(garden_widget: garden_widget)
      end
    end

    context "Content Stripe widget" do
      let(:widget_name) { "Content Stripe" }

      it "callls update_nav_settings" do
        described_instance.should_receive(:update_nav_settings)
        described_instance.save(validate: false)
        described_instance.update(garden_widget: garden_widget)
      end
    end
  end
end

describe Widget do
  it_behaves_like UpdateNavSettings
end
