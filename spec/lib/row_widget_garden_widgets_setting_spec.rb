require 'spec_helper'

describe RowWidgetGardenWidgetsSetting do
  let!(:legit_widget) { Fabricate(:garden_widget, name: "Legit") }
  let!(:row_widget) { Fabricate(:garden_widget, name: "Row") }
  let!(:analytics_widget) { Fabricate(:garden_widget, name: "Analytics") }
  let!(:typekit_widget) { Fabricate(:garden_widget, name: "Typekit") }
  let!(:meta_widget) { Fabricate(:garden_widget, name: "Meta") }

  describe "#value" do
    subject { described_class.new.value }

    it "does not include the Row widget" do
      subject.should_not include(row_widget.name)
    end

    it "does not include the Analytics widget" do
      subject.should_not include(analytics_widget.name)
    end

    it "does not include the Typekit widget" do
      subject.should_not include(typekit_widget.name)
    end

    it "does not include the Meta widget" do
      subject.should_not include(meta_widget.name)
    end

    it "only includes legit widgets" do
      subject.should eq([legit_widget.name])
    end
  end
end
