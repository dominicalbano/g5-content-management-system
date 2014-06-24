require "spec_helper"

describe LayoutWidgetDestroyer do
  let!(:widget) { Fabricate(:widget) }
  let!(:widget_one) { Fabricate(:widget) }
  let!(:widget_two) { Fabricate(:widget) }
  let!(:widget_unrelated) { Fabricate(:widget) }
  let!(:setting) { Fabricate(:setting, owner: widget) }
  let(:destroyer) { described_class.new(setting, id_settings) }
  let(:id_settings) do
    ["row_one_widget_id", "row_two_widget_id",
     "row_three_widget_id", "row_four_widget_id"]
  end

  let!(:id_setting_one) do
    Fabricate(:setting, name: id_settings.first, owner: widget, value: widget_one.id )
  end

  let!(:id_setting_two) do
    Fabricate(:setting, name: id_settings.second, owner: widget, value: widget_two.id )
  end

  describe "#destroy" do
    it "destroys the setting's widget's child widgets" do
      expect { destroyer.destroy }.to change{ Widget.count }.from(4).to(2)
    end

    it "does not destroy un-releated widgets" do
      widget_unrelated.should_not_receive(:destroy)
      destroyer.destroy
    end
  end
end
