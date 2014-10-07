require 'spec_helper'

describe RowWidgetGardenWidgetsSetting do
  let!(:garden_widget) { Fabricate(:garden_widget) }
  let!(:row_widget) { Fabricate(:garden_widget, name: "Row") }

  describe "#value" do
    subject { described_class.new.value }

    it "does not include the Row widget" do
      subject.should eq([garden_widget.name])
    end
  end
end
