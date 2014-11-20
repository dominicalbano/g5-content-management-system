require "spec_helper"

shared_examples_for AfterCreateUpdateNavigationWidgets do
  let(:described_instance) { described_class.new(garden_widget: garden_widget) }

  describe ".after_create" do
    let(:garden_widget) { Fabricate(:garden_widget, name: widget_name) }

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
end

describe Widget do
  it_behaves_like AfterCreateUpdateNavigationWidgets
end
