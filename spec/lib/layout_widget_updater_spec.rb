require "spec_helper"

describe LayoutWidgetUpdater do
  let!(:widget) { Fabricate(:widget) }
  let!(:setting) { Fabricate(:setting, name: name, owner: widget) }
  let(:updater) { described_class.new(setting, name_settings, id_settings) }
  let(:name_settings) do
    ["row_one_widget_name", "row_two_widget_name",
     "row_three_widget_name", "row_four_widget_name"]
  end
  let(:id_settings) do
    ["row_one_widget_id", "row_two_widget_id",
     "row_three_widget_id", "row_four_widget_id"]
  end

  describe "#update" do
    after { updater.update }

    context "a setting name not within name settings" do
      let(:name) { "Foo" }

      it "does not create a new widget" do
        updater.should_not_receive(:create_new_widget)
      end

      it "does not destroy the old widget" do
        updater.should_not_receive(:destroy_old_widget)
      end

      it "does not assign the new widget" do
        updater.should_not_receive(:assign_new_widget)
      end
    end

    context "a setting name within name settings" do
      let(:name) { name_settings[0] }

      it "creates a new widget" do
        updater.should_receive(:create_new_widget)
      end

      it "destroys the old widget" do
        updater.should_receive(:destroy_old_widget)
      end

      it "assigns the new widget" do
        updater.should_receive(:assign_new_widget)
      end
    end
  end
end
